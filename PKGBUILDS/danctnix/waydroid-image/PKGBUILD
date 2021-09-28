# Maintainer: Danct12 <danct12@disroot.org>
# Contributor: Bart Ribbers <bribbers@disroot.org>

_pkgver_images_system="17.1-20210928"
_pkgver_images_vendor="17.1-20210928"
pkgname=waydroid-image
pkgver="${_pkgver_images_system//-/_}"
pkgrel=1
pkgdesc="A container-based approach to boot a full Android system on a regular Linux system (Android image)"
arch=('x86_64' 'i686' 'armv7h' 'aarch64')
license=('Apache')
url='https://github.com/waydroid'
depends=('waydroid')
source_i686=(https://sourceforge.net/projects/waydroid/files/images/system/lineage/waydroid_x86/lineage-$_pkgver_images_system-VANILLA-waydroid_x86-system.zip
  https://sourceforge.net/projects/waydroid/files/images/vendor/waydroid_x86/lineage-$_pkgver_images_vendor-MAINLINE-waydroid_x86-vendor.zip)
source_x86_64=(https://sourceforge.net/projects/waydroid/files/images/system/lineage/waydroid_x86_64/lineage-$_pkgver_images_system-VANILLA-waydroid_x86_64-system.zip
  https://sourceforge.net/projects/waydroid/files/images/vendor/waydroid_x86_64/lineage-$_pkgver_images_vendor-MAINLINE-waydroid_x86_64-vendor.zip)
source_armv7h=(https://sourceforge.net/projects/waydroid/files/images/system/lineage/waydroid_arm/lineage-$_pkgver_images_system-VANILLA-waydroid_arm-system.zip
  https://sourceforge.net/projects/waydroid/files/images/vendor/waydroid_arm/lineage-$_pkgver_images_vendor-MAINLINE-waydroid_arm-vendor.zip)
source_aarch64=(https://sourceforge.net/projects/waydroid/files/images/system/lineage/waydroid_arm64/lineage-$_pkgver_images_system-VANILLA-waydroid_arm64-system.zip
  https://sourceforge.net/projects/waydroid/files/images/vendor/waydroid_arm64/lineage-$_pkgver_images_vendor-MAINLINE-waydroid_arm64-vendor.zip)

case "$CARCH" in
  aarch64) _imgarch="arm64" ;;
  armv7h) _imgarch="arm" ;;
  *) _imgarch="$CARCH" ;;
esac

package() {
  install -dm755 "$pkgdir/usr/share/waydroid-extra/images"

  # makepkg have extracted the zips
  mv "$srcdir/system.img" "$pkgdir/usr/share/waydroid-extra/images"
  mv "$srcdir/vendor.img" "$pkgdir/usr/share/waydroid-extra/images"
}

sha256sums_x86_64=('5893afeb081cbcd5bca08e123510fc7563bc8b05dacc24a6fae485f347441945'
                   'bdf5a3115f423bab4a3f613775daf57bc00ab369ae30b264c22a32abafdc04b7')
sha256sums_i686=('76e8e615467ccaab576430afff48df8f218aaca2299e886bbc0194f791e23259'
                 '1903ccb97d9ca8298ab485aa1d70b7a30e9b91ec8147a805aecc100693452811')
sha256sums_armv7h=('9ce052e93ba2f26be410834e3021f8c6639b72e13c584ae64aac1b407f468555'
                   '65ad4ab1579eb0e7947f124ee51d0f27457a1e7261ad40e6a28b5ac916c7792d')
sha256sums_aarch64=('58d8cbed6d9ceac756963972ba448e4e0b937586142d35bce496a5266923ef32'
                    '04f6705dbd26b1282b4c4b7a8d8535d2edd33ae93baec411e378a8afeed7efbf')
