#!/bin/bash

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
    esac
done

if [[ $PKG_REPO && $PKG_ARCH && $PKG_NAME ]]; then
	guzuta build --arch $PKG_ARCH --chroot-dir ./chroot-$PKG_ARCH --repo-name $PKG_REPO --repo-dir ./repo/$PKG_REPO/$PKG_ARCH --srcdest ./sources --logdest ./logs PKGBUILDS/$PKG_REPO/$PKG_NAME
else
	echo "Invalid Command!"
fi
