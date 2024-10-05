# Maintainer: Adam Thiede <me@adamthiede.com>
pkgname=ttyescape
pkgver=1.0.2
pkgrel=1
pkgdesc="Daemon to allow users to escape to a tty"
url="https://gitlab.com/postmarketOS/ttyescape"
arch=(any)
license=("GPL2")
depends=(buffyboard terminus-font kbd hkdm)

source=(
  ${url}/-/archive/${pkgver}/${pkgname}-${pkgver}.tar.gz
  etc-conf-d-ttyescape.conf
)

package() {
  install -Dm755 "${srcdir}/${pkgname}-${pkgver}/togglevt.sh" "${pkgdir}/usr/bin/togglevt.sh"

  install -Dm644 "${srcdir}/${pkgname}-${pkgver}/ttyescape-hkdm.toml" "${pkgdir}/etc/hkdm/config.d/ttyescape.toml"

  install -Dm644 "${srcdir}/etc-conf-d-ttyescape.conf" "${pkgdir}/etc/conf.d/ttyescape.conf"
}

post_install() {
  systemctl enable hkdm.service
}

sha512sums=(
"844ea5641b83ded3545711ba1560c5acff50e46fd04d5a857c26979cdf83f644f4dfeecdbbb9d520d5147b14c443b9099b6b8097baa814855ee866299a89d95e"
"1c5a3733be8b4f454dfdd8555049f312ed5bb87e87101303cf445fbbd9ce2b64a5b6131b5b15f5dd5c1ff5c945fb54bb1a58bf8374415c750f88f183530c7c3e"
)

