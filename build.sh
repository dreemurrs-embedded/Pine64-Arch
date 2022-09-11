#!/bin/env sh

i=1
while [ $i -lt $(($#+1)) ];
do
        i=$((i+1))
        case "$(eval "echo \"\$$i\"")" in
        "--arch")
                i=$((i+1))
                PKG_ARCH="$(eval "echo \"\$$i\"")"
                ;;
        "--repo")
                i=$((i+1))
                PKG_REPO="$(eval "echo \"\$$i\"")"
                ;;
        "--pkg")
                i=$((i+1))
                PKG_NAME="$(eval "echo \"\$$i\"")"
        esac
done
if [ "$PKG_REPO" ] && [ "$PKG_ARCH" ] && [ "$PKG_NAME" ];

then
        guzuta build "--arch $PKG_ARCH --chroot-dir ./chroot-$PKG_ARCH --repo-name $PKG_REPO --repo-dir ./repo/$PKG_REPO/$PKG_ARCH --srcdest ./sources --logdest ./logs PKGBUILDS/$PKG_REPO/$PKG_NAME"
else
        printf "Invalid Command!\n"
fi
