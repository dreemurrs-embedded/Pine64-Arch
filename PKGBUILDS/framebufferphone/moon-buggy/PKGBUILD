# Maintainer: Robert Hamblin <hamblingreen@hotmail.com>
# Contributor: Jaroslav Lichtblau <dragonlord@aur.archlinux.org>
# Contributor: Dale Blount <dale@archlinux.org>
# Contributor: Tom Newsom <Jeepster@gmx.co.uk>

pkgname=moon-buggy
pkgver=1.0.51
pkgrel=2
pkgdesc="Moon Buggy is a simple game for the text mode"
arch=('i686' 'x86_64' 'aarch64')
url="http://seehuhn.de/comp/moon-buggy"
license=('GPL2')
depends=('ncurses')
options=('!emptydirs')
install=$pkgname.install
source=("http://seehuhn.de/data/$pkgname-$pkgver.tar.gz"
	"Makefile.in.patch"
	"config.patch")
sha256sums=('352dc16ccae4c66f1e87ab071e6a4ebeb94ff4e4f744ce1b12a769d02fe5d23f'
            '985df74c531400d3cba8ef3a8bc3c2fcfcc53efb42f1430c04b1a971108ca73c'
            '6f8e82c566aafc5bf0ddf4ab4ea3381fa723278bc1744bc6923bcf9cd03d4283')

prepare() {
  cd "${srcdir}"/$pkgname-$pkgver

  patch -Np0 -i ${srcdir}/Makefile.in.patch
  patch --strip=1 < ${srcdir}/config.patch
}

build() {
  cd "${srcdir}"/$pkgname-$pkgver

  ./configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info
  make
}

package() {
  cd "${srcdir}"/$pkgname-$pkgver

  make DESTDIR="${pkgdir}" install
  rm "${pkgdir}"/usr/share/info/dir
}
