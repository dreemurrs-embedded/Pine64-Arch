#!/bin/sh

# Copyright (C) 2017-2020 postmarketOS

# This routing script was taken from device-pine64-pinephone package
# from pmOS.

# Current modem routing
#
#  1 - Digital PCM
#  0 - I2S master
#  0 - Primary mode (short sync)
#  2 - 512kHz clock (512kHz / 16bit = 32k samples/s)
#  0 - 16bit linear format
#  1 - 16k sample/s
#  1 - 1 slot
#  1 - map to first slot (the only slot)
#
QDAI_CONFIG="1,0,0,2,0,1,1,1"

DEV=/dev/EG25.AT

# Read current config
RET=$(echo "AT+QDAI?" | atinout - $DEV -)

if echo $RET | grep -q $QDAI_CONFIG
then
	echo "Modem audio already configured"
	exit 0
fi


# Modem not configured, we need to send it the digital interface configuration,
# then reboot it
RET=$(echo "AT+QDAI=$QDAI_CONFIG" | atinout - $DEV -)

if echo $RET | grep -q OK
then
	echo "Successfully configured modem audio"
else
	echo "Failed to set modem audio up: $RET"
	exit 1
fi

# Reset module
# 1 Set the mode to full functionality (vs 4: no RF, and 1: min functionality)
# 1 Reset the modem before changing mode (only available with 1 above)
#
RET=$(echo "AT+CFUN=1,1" | atinout - $DEV -)

if echo $RET | grep -q OK
then
	echo "Successfully reset the modem to apply audio configuration"
else
	echo "Failed to reset the modem to apply audio configuration: $RET"
fi
