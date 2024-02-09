#!/bin/bash

# TODO: set -e and trap exit cleanup
shopt -s extglob
shopt -s nullglob

DB_EXT=".tar.gz"

err() {
	echo "$@"
	exit 1
}

add_all_pkgs() {
	repo-add "$REPO_DB" "$PKG_REPO_DIR"/*.pkg.tar.*
}

rebuild_database() {
	rm "$PKG_REPO_DIR/$PKG_REPO."{db,files}*
	add_all_pkgs
}

for ((i = 1; i < ($#+1); i++)); do
	case "${!i}" in
		--arch)
			((++i))
			PKG_ARCH="${!i}"
			;;
		--repo)
			((++i))
			PKG_REPO="${!i}"
			;;
		--pkg)
			((++i))
			PKG_NAME="${!i}"
			;;
		--unclean)
			((++i))
			UNCLEAN="1"
			;;
	esac
done


#
# Interenal variables
#

# Assume this script is always in the root folder of the repo
# TODO: repo is used to mean both the source repository,
# and the package repository
REPO_DIR=${REPO_DIR:-$(dirname "$(realpath -s "$0")")}
PKG_REPO_DIR="${PKG_REPO_DIR:-$REPO_DIR/repo/$PKG_REPO/$PKG_ARCH}"
REPO_DB="$PKG_REPO_DIR/$PKG_REPO.db$DB_EXT"

# rebuild_database
# exit 0

# TODO: detect corssbuild for arm
if [ "$PKG_ARCH" = "aarch64" ]; then
	MAEKCHROOTPKG=${MAEKCHROOTPKG:-makearmpkg}
else
	MAEKCHROOTPKG=${MAEKCHROOTPKG:-makechrootpkg}
fi

CHROOT="${CHROOT:-$REPO_DIR/chroot-$PKG_ARCH}"
ARGS="-n"
[ -z "$UNCLEAN" ] && ARGS="$ARGS -cu"

 remove_package() {
	 :
}

# remove_package "$PKG_NAME"
# exit 0

#
# Makepkg settigns
#
export SRCDEST="${SRCDEST:-$REPO_DIR/sources}"
export PKGDEST="$(mktemp -d)"
# export PKGDEST="/tmp/tmp.pjrlw1LoJU"
export LOGDEST="${LOGDEST:-$REPO_DIR/logs}"
# REPO_DIR="${PKGDEST:-$REPO_DIR/repo/$PKG_REPO}"

echo "PKGDEST: $PKGDEST"

if [[ $PKG_REPO && $PKG_ARCH && $PKG_NAME ]]; then
	mkdir -p "$PKG_REPO_DIR"
	# Build package
	pushd "PKGBUILDS/$PKG_REPO/$PKG_NAME" || err "failed to pushd"
	$MAEKCHROOTPKG $ARGS -r "$CHROOT"
	popd || err "failed to popd"

	# Move built files, and update database
	for package in "$PKGDEST"/*; do
		cp "$package" "$PKG_REPO_DIR"
		repo-add "$REPO_DB" "$PKG_REPO_DIR/$(basename "$package")"
		echo "built package: $package"
	done

	rm -rf "$PKGDEST"
else
	echo "Invalid Command!"
fi
