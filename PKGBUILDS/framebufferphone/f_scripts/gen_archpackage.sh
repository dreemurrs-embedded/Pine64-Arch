#!/usr/bin/env osh
# This is basically a script that generates a PKGBUILD for 
# f_scripts with each subpackage. So this is a metaprogramming script
# that generates another script..

# Make sure to run `makepkg --nobuild` to grab, extract, and patch
# sources.

header() {
  echo '# Maintainer: Bobby Hamblin <hamblingreen@hotmail.com>
# Contributor: Miles Alan <m@milesalan.com>

pkgbase=f_scripts
pkgname=('"'"'f_audio'"'"' '"'"'f_files'"'"' '"'"'f_game'"'"' '"'"'f_maps'"'"' '"'"'f_networks'"'"' '"'"'f_phone'"'"' '"'"'f_rss'"'"' '"'"'f_theme'"'"' '"'"'f_timer'"'"' '"'"'f_web'"'"' '"'"'f_youtube'"'"')
pkgver='$(git tag | tail -n1)'
pkgrel=1
pkgdesc="Framebufferphone prompt-driven scripts which are compatible with fbp"
url="http://git.sr.ht/~mil/f_scripts"
arch=('"'"'any'"'"')
license=('"'"'GPL-3.0-or-later'"'"')
depends=('"'"'oil'"'"')
source=("https://git.sr.ht/~mil/f_scripts/archive/$pkgver.tar.gz"
	"f_scripts.patch")
sha256sums=('"'"'SKIP'"'"'
	    '"'"'SKIP'"'"')

prepare() {
	patch --directory="f_scripts-$pkgver" --forward --strip=1 --input="$srcdir/f_scripts.patch"
}
'
}

gen() {
  for FILE in ./src/f_scripts-0.4/scripts/f_*; do
    unset DEP DEC
    . "$FILE" nonexistentfn 2>/dev/null
    SCRIPTNAME="$(basename "$FILE")"

    echo 'package_'${SCRIPTNAME}'() {
	pkgdesc="'$DEC'"
	depends=('$DEP')
	provides=('"'"''${SCRIPTNAME}''"'"')

	mkdir -p "$pkgdir/usr/bin"
	install "$srcdir/f_scripts-$pkgver/scripts/'$SCRIPTNAME'" "$pkgdir/usr/bin/'$SCRIPTNAME'"
}
'
  done
}

main() {
  cd "$(dirname $(realpath $0))"
  header 
  gen
}

if [ -n "$1" ]; then "$@"; else main; fi
