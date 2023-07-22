# Maintainer: Sebastian J. Bronner <waschtl@sbronner.com>

pkgname=libnsfb
pkgver=0.2.2
pkgrel=1
pkgdesc='Framebuffer abstraction library'
arch=('any')
url="https://www.netsurf-browser.org/projects/$pkgname/"
license=('MIT')
depends=('glibc')
makedepends=('netsurf-buildsystem')
source=("https://source.netsurf-browser.org/$pkgname.git/snapshot/$pkgname-release/$pkgver.tar.bz2")
sha256sums=('bd4a2370d82f057f2465def204f2a6451ba993ad367325939f6f261a2c920943')
_makedir=$pkgname-release/$pkgver
_makeopts="-C $_makedir PREFIX=/usr COMPONENT_TYPE=lib-shared"

build() {
	make $_makeopts
}

check() {
	make $_makeopts test
}

package() {
	local installopts='--mode 0644 -D --target-directory'
	local shrdir="$pkgdir/usr/share"
	local licdir="$shrdir/licenses/$pkgname"
	local docdir="$shrdir/doc/$pkgname"
	install $installopts "$licdir" $_makedir/COPYING
	install $installopts "$docdir" $_makedir/{README,usage}
	make $_makeopts DESTDIR="$pkgdir" install
}
