# Maintainer: Danct12 <danct12@disroot.org>

pkgname=python-gbinder
pkgver=1.0.0
pkgrel=1
pkgdesc="Python bindings for libgbinder"
arch=('x86_64' 'i686' 'armv7h' 'aarch64')
url="https://github.com/erfanoabdi/gbinder-python"
license=('GPL')
depends=('libgbinder')
makedepends=('git' 'python-setuptools' 'cython')
_commit="2e1e05c0a0240d6c06e9bbe9b22dcc35c2e0211c"
source=(${pkgname}::git+https://github.com/erfanoabdi/gbinder-python.git#commit=${_commit})
sha512sums=('SKIP')

pkgver() {
  cd ${pkgname}
  git describe --tags | sed 's/^v//;s/-/+/g'
}

build() {
  cd ${pkgname}
  python3 setup.py build --cython
}

package() {
  cd ${pkgname}
  python3 setup.py install --prefix=/usr --root="$pkgdir"
}
