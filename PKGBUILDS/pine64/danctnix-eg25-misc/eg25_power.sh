#!/bin/bash

# Copyright (C) 2020 Dreemurrs Embedded Labs / DanctNIX Community.
# SPDX-License-Identifier: GPL-2.0-only

if [ "$1" = "start" ]; then
	echo "Starting EG25 WWAN Module"
	echo 1 > /sys/class/modem-power/modem-power/device/powered
elif [ "$1" = "stop" ]; then
	echo "Stopping EG25 WWAN Module"
	echo 0 > /sys/class/modem-power/modem-power/device/powered
else
	echo "No command specified or invalid command!"
fi
