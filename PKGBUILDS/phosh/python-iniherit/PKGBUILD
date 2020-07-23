# Maintainer: lll2yu <lll2yu@protonmail.com>

pkgname=python-iniherit
pkgver=0.3.9
pkgrel=1
pkgdesc='A ConfigParser subclass with file-specified inheritance.'
arch=(any)
url=http://github.com/cadithealth/iniherit
license=(MIT 'custom:Public Domain')
depends=(python python-six)
makedepends=(python-pip python-wheel)
source=(https://files.pythonhosted.org/packages/65/a5/5bb95059c92c23560a80bcd599bc737a4175b275b3a577cb19f66bd302e3/iniherit-$pkgver.tar.gz)
sha256sums=('06d90849ff0c4fadb7e255ce31e7c8e188a99af90d761435c72b79b36adbb67a')

package() {
	cd iniherit-$pkgver
	python setup.py install -O1 --root="$pkgdir"
}
