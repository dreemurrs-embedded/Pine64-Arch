# Maintainer: Adam Thiede <me@adamthiede.com>
pkgname=buffyboard
pkgver=0.2.0
pkgrel=1
_lv_drivers_commit="33983bcb0a9bfd0a4cf44dba67617b9f537e76f3"
_lvgl_commit="a2b555e096f7d401b5d8e877a6b5e81ff81c747a"
_squeek2lvgl_commit="e3ce01bc38020b21bc61844fa1fed1a4f41097c5"
pkgdesc="Touch-enabled framebuffer keyboard (not only) for vampire slayers"
arch=(x86_64 armv7h aarch64)
url="https://gitlab.com/cherrypicker/buffyboard"
license=('GPL3')
depends=(libinput)
makedepends=(meson libinput libxkbcommon linux-headers udev)
source=(https://gitlab.com/cherrypicker/buffyboard/-/archive/${pkgver}/buffyboard-${pkgver}.tar.gz
      https://github.com/lvgl/lv_drivers/archive/${_lv_drivers_commit}.tar.gz
      https://github.com/lvgl/lvgl/archive/${_lvgl_commit}.tar.gz
      https://gitlab.com/cherrypicker/squeek2lvgl/-/archive/${_squeek2lvgl_commit}/buffyboard-${_squeek2lvgl_commit}.tar.gz)

build() {
  mkdir -p "${srcdir}/${pkgname}-${pkgver}/lvgl" "${srcdir}/${pkgname}-${pkgver}/lv_drivers" "${srcdir}/${pkgname}-${pkgver}/squeek2lvgl"
  mv "${srcdir}/lvgl-${_lvgl_commit}/"* "${srcdir}/${pkgname}-${pkgver}/lvgl"
  mv "${srcdir}/lv_drivers-${_lv_drivers_commit}/"* "${srcdir}/${pkgname}-${pkgver}/lv_drivers"
  mv "${srcdir}/squeek2lvgl-${_squeek2lvgl_commit}/"* "${srcdir}/${pkgname}-${pkgver}/squeek2lvgl"
  arch-meson ${pkgname}-${pkgver} _build
  meson compile -C _build
}

package() {
  DESTDIR=${pkgdir} meson install --no-rebuild -C _build
}

sha512sums=(
'6a504ed775ebcc03276b2c10e299e894cdc3ea3c7e40d263e449982dd6ac6a7f37fe2094c84e6d0b92c3f965aefc38e606de66bd74d8d375bb2168acb0c0284e' 
'788ab2ac810580222e85c580a6e7d94783b6e4a29688274d6eb85ec7e9cbe8c146452baf9b2c8ecde135b9e68539218affd4d3bde40667ed1e2da2fa9b9feea4'
'6db243760407176d57bc1aafc9145f8f089e6be4b74afff966ca6fbf29605ccd30afbd113412c7259040894eb7506a90a40c07c0e0be1c7bfbaab01c5ea2727c'
'57fb6bb0445e27c5529f96499f744f64038c549f741ff17a2fc83902e7bdbcf1358c4a3eb37848f89e98d1e6011bb46581ab081bf0b0e01350de2f75e58e2f33')
