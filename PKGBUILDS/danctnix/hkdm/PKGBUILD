# Maintainer: Adam Thiede <me@adamthiede.com>
pkgname=hkdm
pkgver=0.1.8
pkgrel=1
pkgdesc="Lighter-weight hotkey daemon"
url="https://gitlab.com/postmarketOS/hkdm"
arch=(x86_64 aarch64)
license=("GPL3")
source=(https://gitlab.com/postmarketOS/hkdm/-/archive/${pkgver}/hkdm-${pkgver}.tar.gz
  hkdm.service)
makedepends=(rust libevdev)

build() {
  cd ${srcdir}/hkdm-${pkgver}
  cargo fetch --locked
  cargo build --frozen --no-default-features --release
  cargo test --frozen --no-default-features
}

package() {
  cd "${srcdir}/hkdm-${pkgver}"
  install -Dm644 hkdm.example.toml ${pkgdir}/etc/hkdm/config.d/hkdm.example
  install -Dm755 target/release/hkdm ${pkgdir}/usr/bin/hkdm
  install -Dm644 ${srcdir}/hkdm.service ${pkgdir}/etc/systemd/system/hkdm.service
}

sha512sums=(
"baadb5a21498f3d748dc46a9d0e25204fc3b7965dde2b2d54edc54b8cc48020251ade00a6ee274fe0ea5b824e8fe23f3c5188b0de3ef4227c5fef00120c5a5b8"
"6e2f6f377e73e2618c14858707ed29cde1ff22614531b33bf3aa825ad7d41c64d69ef8da8db4327813969d9b076d6706df89b6a10c4dace0f29ae6c7f0f456ca"
)
