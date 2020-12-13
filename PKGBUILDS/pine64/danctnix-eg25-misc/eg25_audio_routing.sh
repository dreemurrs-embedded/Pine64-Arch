#!/bin/sh

# Copyright (C) 2020 - Dreemurrs Embedded Labs / DanctNIX Community
# Copyright (C) 2020 - postmarketOS Contributors
# SPDX-License-Identifier: GPL-2.0-only

while [ ! -e /dev/EG25.AT ]; do sleep 0.2 ; done

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
