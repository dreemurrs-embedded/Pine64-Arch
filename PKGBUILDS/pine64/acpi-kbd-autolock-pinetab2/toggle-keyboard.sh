#!/bin/sh

ACTION=bind
MESSAGE=on
if [[ "$3" = "close" ]]
then
	ACTION=unbind
	MESSAGE=off
fi

KEYBOARD=4-1
#KEYBOARD=`grep -r --include=uevent Touchpad /sys/devices/ | cut -d/ -f7 | grep -v : | sort | uniq`

echo "$KEYBOARD" > /sys/bus/usb/drivers/usb/"$ACTION"

for user in `who | cut -f1 -d\  | sort | uniq`
do
	sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"`id -u $user`"/bus \
		notify-send -a 'PineTab2 case' "Keyboard turned $MESSAGE."
done
