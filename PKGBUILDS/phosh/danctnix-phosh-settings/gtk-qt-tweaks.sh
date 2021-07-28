#!/bin/sh

# Use GLES in GDK
export GDK_GL
GDK_GL=gles

# Most pure GTK3 apps use wayland by default, but some,
# like Firefox, need the backend to be explicitely selected.
export MOZ_ENABLE_WAYLAND=1

export QT_QPA_PLATFORM=wayland
