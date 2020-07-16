#!/bin/sh

CAMERA_DEV=`v4l2-ctl --list-devices | awk '/Video Capture/{getline; print $1}'`
if [ ! -c "$CAMERA_DEV" ]; then
    echo "$CAMERA_DEV is not a character device, quitting..."
    exit 1
fi

# Configure camera
media-ctl -d $CAMERA_DEV --set-v4l2 '"ov5640 3-004c":0[fmt:YUYV8_2X8/1280x720]'
media-ctl -d $CAMERA_DEV --set-v4l2 '"gc2145 3-003c":0[fmt:YUYV8_2X8/1280x720]'

# Select camera
if [ "$1" = "front" ]; then
    media-ctl -d $CAMERA_DEV --links '"ov5640 3-004c":0->"sun6i-csi":0[0]'
    media-ctl -d $CAMERA_DEV --links '"gc2145 3-003c":0->"sun6i-csi":0[1]'
else
    media-ctl -d $CAMERA_DEV --links '"gc2145 3-003c":0->"sun6i-csi":0[0]'
    media-ctl -d $CAMERA_DEV --links '"ov5640 3-004c":0->"sun6i-csi":0[1]'
fi
