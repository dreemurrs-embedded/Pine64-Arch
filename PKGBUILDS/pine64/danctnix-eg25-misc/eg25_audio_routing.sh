#!/bin/sh

# Copyright (C) 2020 - Dreemurrs Embedded Labs / DanctNIX Community
# Copyright (C) 2020 - postmarketOS Contributors
# SPDX-License-Identifier: GPL-2.0-only

while [ ! -e /dev/EG25.AT ]; do sleep 0.2 ; done

# Avoid USB resets
echo "auto" > /sys/bus/usb/devices/3-1/power/control
echo "3000" > /sys/bus/usb/devices/3-1/power/autosuspend_delay_ms
echo "enabled" > /sys/bus/usb/devices/3-1/power/wakeup
echo "1" > /sys/bus/usb/devices/3-1/avoid_reset_quirk
echo "0" > /sys/bus/usb/devices/3-1/power/persist
echo "Configured sysfs entries to avoid USB resets"

# Setup VoLTE
if echo "AT+QMBNCFG=\"AutoSel\",1" | atinout - /dev/EG25.AT - | grep -q OK; then
        echo "Successfully configured VoLTE to AutoSel"
else
        echo "Failed to configure VoLTE Profile: $?"
fi

# Enable VoLTE
if echo "AT+QCFG=\"ims\",1" | atinout - /dev/EG25.AT - | grep -q OK; then
        echo "Successfully enabled VoLTE"
else
        echo "Failed to enable VoLTE: $?"
fi
