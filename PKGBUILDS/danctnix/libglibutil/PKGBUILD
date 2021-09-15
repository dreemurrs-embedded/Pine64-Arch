# Maintainer: Danct12 <danct12@disroot.org>

pkgname=libglibutil
pkgver=1.0.55
pkgrel=1
pkgdesc="Library of glib utilities"
arch=('x86_64' 'i686' 'armv7h' 'aarch64')
url="https://git.sailfishos.org/mer-core/libglibutil"
license=('BSD')
depends=('glib2')
makedepends=('git')
_commit="7321c8e782bbe5a679446d9df03d7c22abe8e73b" # tags/1.0.55
source=(${pkgname}::git+https://git.sailfishos.org/mer-core/libglibutil.git#commit=${_commit})
sha512sums=('SKIP')

pkgver() {
  cd ${pkgname}
  git describe --tags | sed 's/^v//;s/-/+/g'
}

build() {
  cd ${pkgname}
  make KEEP_SYMBOLS=1 release pkgconfig
}

package() {
  cd ${pkgname}
  make install-dev DESTDIR="${pkgdir}"
}
