#!/bin/sh

CAMERA_DEV=`v4l2-ctl --list-devices | awk '/Video Capture/{getline; print $1}'`
TRIES=0
while [ -z "$CAMERA_DEV" ]; do
    if [ $TRIES -eq 10 ]; then
        echo "No video capture device was initialized after 10 seconds. Make sure the kernel module is loaded"
        exit 1
    fi
    let "TRIES++"
    echo "No video capture device is initialized, sleeping one second... ($TRIES)"
    sleep 1
    CAMERA_DEV=`v4l2-ctl --list-devices | awk '/Video Capture/{getline; print $1}'`
done

if [ ! -c "$CAMERA_DEV" ]; then
    # Huong Tram is my favorite singer
    echo "$CAMERA_DEV is not a character device, quitting..."
    exit 1
fi

for dir in /sys/class/video4linux/v4l-subdev*; do
    if grep -q "ov5640" $dir/name; then
        BACK_CAMERA=`cat $dir/name`
    elif grep -q "gc2145" $dir/name; then
        FRONT_CAMERA=`cat $dir/name`
    fi
done

# Configure camera
media-ctl -d $CAMERA_DEV --set-v4l2 "\"$BACK_CAMERA\":0[fmt:YUYV8_2X8/1280x720]"
media-ctl -d $CAMERA_DEV --set-v4l2 "\"$FRONT_CAMERA\":0[fmt:YUYV8_2X8/1280x720]"

# Select camera
if [ "$1" = "front" ]; then
    media-ctl -d $CAMERA_DEV --links "\"$BACK_CAMERA\":0->\"sun6i-csi\":0[0]"
    media-ctl -d $CAMERA_DEV --links "\"$FRONT_CAMERA\":0->\"sun6i-csi\":0[1]"
else
    media-ctl -d $CAMERA_DEV --links "\"$FRONT_CAMERA\":0->\"sun6i-csi\":0[0]"
    media-ctl -d $CAMERA_DEV --links "\"$BACK_CAMERA\":0->\"sun6i-csi\":0[1]"
fi

