#!/bin/sh

# Copyright (C) 2020 Dreemurrs Embedded Labs / DanctNIX Community.
# SPDX-License-Identifier: GPL-2.0-only

if [ "$1" = "start" ]; then
	echo "Starting EG25 WWAN Module"

	# GPIO35 is PWRKEY
	# GPIO68 is RESET_N
	# GPIO232 is W_DISABLE#
	for i in 35 68 232
	do
		[ -e /sys/class/gpio/gpio$i ] && continue
		echo $i > /sys/class/gpio/export || return 1
		echo out > /sys/class/gpio/gpio$i/direction || return 1
	done

	echo 0 > /sys/class/gpio/gpio68/value || return 1
	echo 0 > /sys/class/gpio/gpio232/value || return 1

	( echo 1 > /sys/class/gpio/gpio35/value && sleep 2 && echo 0 > /sys/class/gpio/gpio35/value ) || return 1
elif [ "$1" = "stop" ]; then
	echo "Stopping EG25 WWAN Module"

	echo 1 > /sys/class/gpio/gpio68/value
	echo 1 > /sys/class/gpio/gpio232/value

	echo 1 > /sys/class/gpio/gpio35/value && sleep 2 && echo 0 > /sys/class/gpio/gpio35/value
	sleep 30 # We need this to be a clean shutdown as we don't want to corrupt it
else
	echo "No command specified or invalid command!"
fi
