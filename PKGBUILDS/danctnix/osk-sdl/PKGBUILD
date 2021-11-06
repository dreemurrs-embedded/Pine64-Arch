# Maintainer: Danct12 <danct12@disroot.org>
pkgname=osk-sdl
pkgver=0.66
pkgrel=1
pkgdesc="SDL2 On-screen Keyboard for FDE"
arch=(x86_64 armv7h aarch64)
url="https://gitlab.com/postmarketOS/osk-sdl"
license=('GPL3')
depends=(device-mapper cryptsetup sdl2 sdl2_ttf mesa ttf-dejavu)
makedepends=(scdoc meson)
source=($pkgname-$pkgver.tar.gz::https://gitlab.com/postmarketOS/osk-sdl/-/archive/$pkgver/$pkgname-$pkgver.tar.gz
        osk-sdl-hooks
        osk-sdl-install)

build() {
  arch-meson "$pkgname-$pkgver" _build
  meson compile -C _build
}

package() {
  DESTDIR="$pkgdir" meson install --no-rebuild -C _build

  # DejaVu is on a different directory than default
  sed -i 's/\/usr\/share\/fonts\/ttf-dejavu/\/usr\/share\/fonts\/TTF/g' ${pkgdir}/etc/osk.conf

  # Install initramfs
  install -Dm644 ${srcdir}/osk-sdl-hooks ${pkgdir}/usr/lib/initcpio/hooks/osk-sdl
  install -Dm644 ${srcdir}/osk-sdl-install ${pkgdir}/usr/lib/initcpio/install/osk-sdl
}
md5sums=('fb608060dea423d221bdfff9a6101624'
         '2c8345e95abd0f28b495c4e7039e3c2d'
         '241a9cf1013df82665411d92a6f92ba1')
