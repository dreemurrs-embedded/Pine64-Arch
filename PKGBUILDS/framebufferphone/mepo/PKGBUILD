# Maintainer: Rene Hickersberger <r@renehsz.com>
# Contributor: Robert Hamblin <hamblingreen@hotmail.com>
pkgname=mepo
pkgver=1.0
pkgrel=1
pkgdesc="Fast, simple, and hackable OSM map viewer for Linux"
arch=('i686' 'x86_64' 'arm' 'aarch64')
url="https://git.sr.ht/~mil/mepo"
license=('GPL3')
depends=('dmenu' 'jq' 'xdotool' 'curl' 'sdl2' 'sdl2_image' 'sdl2_ttf' 'sdl2_gfx')
makedepends=('zig>=0.9')
checkdepends=('zig>=0.9')
changelog=
source=("$pkgname-$pkgver.tar.gz::$url/archive/$pkgver.tar.gz")
sha512sums=('1dac736ee486931f231458e7a23359a5b359826dd496c28eb11c9ea90f3b42bcb31acca2b528278f27185dd6053ee0378cf14be8d1d96b20ade71c8db4d43253')
sha256sums=('20c56c84456974583b501c34b47c45f229934cfdf10cf904f229b604c7361c80')

build() {
  cd "$pkgname-$pkgver"

  zig build -Drelease-safe=true
}

check() {
  cd "$pkgname-$pkgver"

  zig build test
}

package() {
  cd "$pkgname-$pkgver"

  mkdir -p "$pkgdir/usr/bin"
  install scripts/mepo_* "$pkgdir/usr/bin/"
  install "zig-out/bin/mepo" "$pkgdir/usr/bin/"
}

