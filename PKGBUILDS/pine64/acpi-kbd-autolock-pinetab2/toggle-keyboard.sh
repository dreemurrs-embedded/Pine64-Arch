#!/bin/sh

# NOTE: if the "on"/reactivate version of this command for some reason cannot
# find the saved keyboard USB ID or if the saved ID somehow fails to turn the
# keyboard back on (as indicated by a search for it again in the devices), this
# script will fall back to turning on ALL usb ports.
#
# If for some reason you NEED a usb port to stay off even in the event of an
# error from this script, you will want to uninstall this package!
#
# Most users it won't hurt to turn on all USB ports though; if you're not sure
# whether it's safe to use this, it should be safe.

ACTION=bind
MESSAGE=on
if [[ "$3" = "close" ]]
then
	ACTION=unbind
	MESSAGE=off
fi

KEYBOARD=`grep -r --include=uevent Touchpad /sys/devices/ | cut -d/ -f7 | grep -v : | sort | uniq`

if [ -z "$KEYBOARD" -a -e /var/keyboard-usb-port ]
then
	KEYBOARD=`cat /var/keyboard-usb-port`
fi

if [ -z "$KEYBOARD" ] && [[ "$ACTION" = "unbind" ]]
then
	for user in `who | cut -f1 -d\  | sort | uniq`
	do
		sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"`id -u $user`"/bus \
			notify-send -a 'PineTab2 case' "UNABLE TO FIND KEYBOARD USB PORT."
	done
	set -e
	false
fi

if ! [ -z "$KEYBOARD" ]
then
	echo -n "$KEYBOARD" > /var/keyboard-usb-port
	echo "$KEYBOARD" > /sys/bus/usb/drivers/usb/"$ACTION"
fi

if [[ "$ACTION" = "bind" ]] && ! grep -r --include=uevent Touchpad /sys/devices/ 2>&1 >/dev/null
then
	for device in `ls /sys/bus/usb/devices`
	do
		echo "$device" > /sys/bus/usb/drivers/usb/bind 2>/dev/null
	done
fi

for user in `who | cut -f1 -d\  | sort | uniq`
do
	sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"`id -u $user`"/bus \
		notify-send -a 'PineTab2 case' "Keyboard turned $MESSAGE."
done
