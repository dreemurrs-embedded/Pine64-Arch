#!/bin/bash

# Copyright 2020 - Dreemurrs Embedded Labs / DanctNIX Community
#
# This suspend hook is intended as a workaround for Bluetooth suspend oops:
# https://gitlab.com/pine64-org/linux/-/issues/24

# Uncomment this (or add to profile.d) if you want to suspend properly on Braveheart (disabled due to dmesg spam)
#IT_NEVER_CAME_BACK_ON=1

# Set it to non-empty once it finds the magic string
grep -rq IT_NEVER_CAME_BACK_ON /etc/profile.d && IT_NEVER_CAME_BACK_ON=1

prepare_suspend() {
	echo "Preparing to suspend..."

	# Enable URC caching
	echo "AT+QCFG=\"urc/cache\",1" | atinout - /dev/EG25.AT -

	# Enable Sleep Mode
	echo "AT+QSCLK=1" | atinout - /dev/EG25.AT -

	# Braveheart users need this if they want to suspend properly
	[ -n "$IT_NEVER_CAME_BACK_ON" ] && echo "1c19000.usb" > /sys/bus/platform/drivers/musb-sunxi/unbind
}

resume_all() {
	echo "Resuming the device..."
	hwclock -s
	sleep 1

	# Disable Sleep Mode
	echo "AT+QSCLK=0" | atinout - /dev/EG25.AT -

	# Disable URC caching
	echo "AT+QCFG=\"urc/cache\",0" | atinout - /dev/EG25.AT -

	# Braveheart users need this if they want to suspend properly
	[ -n "$IT_NEVER_CAME_BACK_ON" ] && echo "1c19000.usb" > /sys/bus/platform/drivers/musb-sunxi/bind
}

case $1 in
	pre) prepare_suspend ;;
	post) resume_all ;;
esac
