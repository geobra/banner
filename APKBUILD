# Contributor:
# Maintainer:
pkgname=banner
pkgver=1.0.0
pkgrel=0
pkgdesc="A banner app which displays custom animated message on the (mobile) display"
url="https://github.com/geobra/banner"
arch="all"
license="qpl"
depends="qt6-qtbase qt6-qtdeclarative"
makedepends="cmake qt6-qtbase-dev qt6-qtdeclarative-dev"
checkdepends=""
install=""
subpackages="$pkgname-dev $pkgname-doc"
source="$pkgname-$pkgver.tar.bz2"
builddir="$srcdir/$pkgname-$pkgver"
options="!check"

build() {
	cmake -S . -B build
	cmake --build build
}

package() {
	install -Dm755 "$builddir"/build/banner "$pkgdir"/bin/banner
	install -Dm644 "$srcdir/$pkgname-$pkgver"/resources/banner.desktop "$pkgdir"/usr/share/applications/banner.desktop
	install -Dm644 "$srcdir/$pkgname-$pkgver"/resources/banner.png "$pkgdir"/usr/share/icons/hicolor/256x256/apps/banner.png
}

subpackages=""

sha512sums="
a1cda1b944f7b94898c4ca60563a0f02c9fb1c76eb75d5be941134c109765ee82f63b57a4698f617fc1c178ac377d61a77cb1b888abb30eca9d9c2bf1e661a89  banner-1.0.0.tar.bz2
"
