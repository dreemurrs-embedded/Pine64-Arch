#!/bin/sh

while [ ! -e /dev/EG25.AT ]; do sleep 1 ; done
sleep 4

# Set modem audio configs
if echo "AT+QDAI=1,0,0,2,0,1,1,1" | atinout - /dev/EG25.AT - | grep -q OK; then
        echo "Successfully configured modem audio"
else
        echo "Failed to set modem audio up: $?"
fi

if echo 'AT+QCFG="risignaltype","physical"' | atinout - /dev/EG25.AT - | grep -q OK; then
        echo "Successfully configured modem ring wakeup"
else
        echo "Failed to set modem ring wakeup: $?"
fi
