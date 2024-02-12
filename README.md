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

## Developer notes

To update this Formula to match the `homebrew-core` `openvpn` port version
use:

`brew cat openvpn | egrep -A 2 'url.*releases'`

to extract out the updated URL/mirror/sha256 information, which can then
be inserted into this Formula and used as is (providing there is not a
large change which requires new dependencies).

Within `vi` this can be directly substituted with:

    1G
    /url
    :.,+2!brew cat openvpn | egrep -A 2 'url.*releases'

and it should be ready to upgrade with:

    brew upgrade openvpn-pw-save

(Since there are no pre compiled binary "bottles" it should automatically
build the upgrade from source.)

## License

Since this formula is a minor variation of the [HomeBrew core OpenVPN
formula](https://github.com/Homebrew/homebrew-core/blob/master/Formula/o/openvpn.rb),
it is covered by the same [BSD 2-Clause
License](https://github.com/Homebrew/homebrew-core/blob/master/LICENSE.txt)
as the HomeBrew core Formulas.  A copy of the BSD 2-Clause license can be
found in [LICENSE.txt](LICENSE.txt).
