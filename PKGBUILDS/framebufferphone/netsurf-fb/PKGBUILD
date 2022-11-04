# Maintainer: Robert Hamblin <hamblingreen@hotmail.com>
# Contributor: Sebastian J. Bronner <waschtl@sbronner.com>

pkgname=netsurf-fb
pkgver=3.10
pkgrel=1
pkgdesc='Lightweight and fast web browser (framebuffer front end)'
arch=(x86_64 i686 aarch64)
url=https://www.netsurf-browser.org/
license=(MIT GPL2)
depends=('curl' 'glibc' 'gperf' 'libdom' 'libjpeg' 'libnsfb' 'libnsutils' 'libpng' 'libsvgtiny' 'libutf8proc' 'libwebp' 'openssl' 'perl-html-parser')
makedepends=('check' 'libcss' 'libnsbmp' 'libnsgif' 'nsgenbind' 'words' 'xxd')
_download_uri=https://download.netsurf-browser.org/netsurf/releases/source
source=(
	$_download_uri/netsurf-$pkgver-src.tar.gz
	utils-idna.patch
)
sha256sums=('36484429e193614685c2ff246f55bd0a6dddf31a018bee45e0d1f7c28851995e'
            '44b019b2484237b1edae8589254250d8fbf8515d883df659c3621cfe0e6d13b4')
_makedir=netsurf-$pkgver
_makeopts="-C $_makedir PREFIX=/usr TARGET=framebuffer"

prepare() {
	# makedepends: patch
	patch --directory=$_makedir --strip=1 < $startdir/utils-idna.patch
}

build() {
	# makedepends: gcc libcss libnsbmp libnsgif make nsgenbind xxd
	make $_makeopts
}

check() {
	# makedepends: check gcc make words
	make $_makeopts test
}

package() {
	# makedepends: coreutils gzip make
	local installopts='--mode 0644 -D --target-directory'
	local shrdir="$pkgdir/usr/share"
	local licdir="$shrdir/licenses/$pkgname"
	local docdir="$shrdir/doc/$pkgname"
	local mandir="$shrdir/man/man1"
	install $installopts "$licdir" $_makedir/COPYING
	install $installopts "$docdir" $_makedir/docs/{netsurf-options.md,UnimplementedJavascript.md,using-framebuffer.md}
	gzip $_makedir/docs/netsurf-fb.1
	install $installopts "$mandir" $_makedir/docs/netsurf-fb.1.gz
	make $_makeopts DESTDIR="$pkgdir" install
}
