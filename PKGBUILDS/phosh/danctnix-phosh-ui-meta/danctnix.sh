# Give us some room to configure things:
export XDG_DATA_DIRS
XDG_DATA_DIRS="/usr/share/danctnix:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

# Use GLES in GDK
export GDK_GL
GDK_GL=gles

# Custom feedbackd theme (mainly haptic)
export FEEDBACK_THEME=/usr/share/feedbackd/themes/danctnix.json
