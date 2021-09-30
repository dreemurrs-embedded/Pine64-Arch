#!/bin/sh

# If Wayland plugin for Qt is installed, launch Qt apps in Wayland.
if [ -f "/usr/lib/qt/plugins/wayland-shell-integration/libxdg-shell.so" ]; then
  export QT_QPA_PLATFORM=wayland
fi

# Use GLES in GDK
export GDK_GL=gles

# Most pure GTK3 apps use wayland by default, but some,
# like Firefox, need the backend to be explicitely selected.
export MOZ_ENABLE_WAYLAND=1
