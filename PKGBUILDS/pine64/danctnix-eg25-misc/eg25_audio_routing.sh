#!/bin/sh

while [ ! -e /dev/EG25.AT ]; do sleep 1 ; done
sleep 4

# DTR is:     
# - PL6/GPIO358 on BH (1.1)
# - PB2/GPIO34 on CE (1.2)

# AP_READY is:                  
# - PL2/GPIO354 on mozzwalds BH (1.1), not connected on others
# - PH7/GPIO231 on CE (1.2)

if grep -q 1.1 /proc/device-tree/model
then
        DTR=358
        AP_READY=354
else
        DTR=34
        AP_READY=231
fi

echo ${DTR} > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio${DTR}/direction
echo 0 > /sys/class/gpio/gpio${DTR}/value

echo ${AP_READY} > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio${AP_READY}/direction
echo 0 > /sys/class/gpio/gpio${AP_READY}/value

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

# Set URC port (Unsolicited Result Code)
if echo "AT+QURCCFG=\"urcport\",\"usbat\"" | atinout - /dev/EG25.AT - | grep -q OK; then
        echo "Successfully configured URC (Unsolicited Result Code)"
else
        echo "Failed to configure URC (Unsolicited Result Code): $?"
fi

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
