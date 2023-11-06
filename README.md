# openvpn (with `--password-save` available)

This is a "fork" of the [HomeBrew Formula for
`openvpn`](https://github.com/Homebrew/homebrew-core/blob/master/Formula/o/openvpn.rb)
which enables the option to load passwords from a file (for automated
OpenVPN logins to servers that use username/password authentication
in addition to TLS certificates, eg, Mikrotik routers).

To install 

`brew install naosnz/openvpn-pw-save/openvpn-pw-save`

Or 

`brew tap naosnz/openvpn-pw-save`
`brew install openvpn-pw-save`

The Formula conflicts with the built in `openvpn` Formula because
they both provide the `openvpn` binary, and service.  The intention
is that it is pretty much a drop in replacement (although obviously
anything depending on the `openvpn` Formula having been installed
will no longer work).
