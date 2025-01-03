# This is a minor variation on the homebrew-core/o/openvpn.rb Formula:
#
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/o/openvpn.rb
#
# available under the same license (BSD-2-Clause):
#
# https://github.com/Homebrew/homebrew-core/blob/master/LICENSE.txt
#
# SPDX-License-Identifier: BSD-2-Clause
#
# Updated by Ewen McNeill <ewen@naos.co.nz>, 2024-12-17
#
class OpenvpnPwSave < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.12.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.12.tar.gz"
  sha256 "1c610fddeb686e34f1367c347e027e418e07523a10f4d8ce4a2c2af2f61a1929"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  option "without-savedpasswords", "Build without support for saved passwords"

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"

  conflicts_with "openvpn", because: "both provide the openvpn binary and service"

  on_linux do
    depends_on "libcap-ng"
    depends_on "libnl"
    depends_on "linux-pam"
    depends_on "net-tools"
  end

  def install
    if build.without? "savedpasswords"
        additional_args = []
    else
        additional_args = [ "--enable-password-save" ]
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          "--prefix=#{prefix}",
                          *additional_args
    inreplace "sample/sample-plugins/Makefile" do |s|
      if OS.mac?
        s.gsub! Superenv.shims_path/"pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"
      else
        s.gsub! Superenv.shims_path/"ld", "ld"
      end
    end
    system "make", "install"

    inreplace "sample/sample-config-files/openvpn-startup.sh",
              "/etc/openvpn", etc/"openvpn"

    (doc/"samples").install Dir["sample/sample-*"]
    (etc/"openvpn").install doc/"samples/sample-config-files/client.conf"
    (etc/"openvpn").install doc/"samples/sample-config-files/server.conf"
  end

  def post_install
    (var/"run/openvpn").mkpath
  end

  service do
    name macos: "homebrew.mxcl.openvpn",
         linux: "homebrew.systemd.openvpn"
    run [opt_sbin/"openvpn", "--config", etc/"openvpn/openvpn.conf"]
    keep_alive true
    require_root true
    working_dir etc/"openvpn"
  end

  test do
    system sbin/"openvpn", "--show-ciphers"
  end
end
