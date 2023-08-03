#!/bin/sh

# Sometimes users may have multiple UI installed and they may choose to run a non-Wayland environment,
# so let's only set these when the session type is Wayland.

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
fi
