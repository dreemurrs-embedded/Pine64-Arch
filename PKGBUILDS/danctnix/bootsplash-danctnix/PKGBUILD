# Maintainer: Danct12 <danct12@disroot.org>
# Contributor: TuxThePenguin
pkgbase=bootsplash-themes
pkgname=('bootsplash-theme-danctnix')
pkgver=2
pkgrel=0
url="https://lists.freedesktop.org/archives/dri-devel/2017-December/160242.html"
arch=('aarch64')
license=('GPL')
makedepends=('git' 'imagemagick')
options=('!libtool' '!emptydirs')

source=("bootsplash-packer-git::git+https://gitlab.manjaro.org/manjaro-arm/packages/extra/bootsplash-packer.git"
	'bootsplash-danctnix.sh'
	'bootsplash-danctnix.initcpio_install'
	'spinner.gif'
	'danctnix.png'
	'packagekit-hide-bootsplash.service')

sha256sums=('SKIP'
            'ea016e9c4d00368e83c01cd5382f461210028e74c4e9852b4d3cb91b1eb48b9e'
            '3b075471616044aae47d949d88857b3bc51f5abad94d2024d2ceb87cc2778c1c'
            '48a3b7ddc14be47609b77710d0bb0754718b6c9da5230183842a08fbd3b5a125'
            '33e07b10e5e700d13759f5eb9b0feec90336f61c19909aa3fa9109db43795806'
            '52586beb9cc92169cf17cfdb3039fe9d5422ee861d13931310593984be176adc')

build() {
  # Build bootsplash-packer first
  cd bootsplash-packer-git
  gcc $CFLAGS -o bootsplash-packer bootsplash-packer.c
  mv bootsplash-packer "$srcdir"
  cd "$srcdir"

  # Generate the splash image
  sh ./bootsplash-danctnix.sh
}

package_bootsplash-theme-danctnix() {
  pkgdesc="Bootsplash Theme with DanctNIX + Arch logo"

  install -Dm644 "$srcdir/bootsplash-danctnix" "$pkgdir/usr/lib/firmware/bootsplash-themes/danctnix/bootsplash"
  install -Dm644 "$srcdir/bootsplash-danctnix.initcpio_install" "$pkgdir/usr/lib/initcpio/install/bootsplash-danctnix"

  install -Dm644 "$srcdir/packagekit-hide-bootsplash.service" "$pkgdir/usr/lib/systemd/system/packagekit-hide-bootsplash.service"
  mkdir -p "$pkgdir/usr/lib/systemd/system/system-update.target.wants"
  ln -s ../packagekit-hide-bootsplash.service "$pkgdir/usr/lib/systemd/system/system-update.target.wants/packagekit-hide-bootsplash.service"
}
