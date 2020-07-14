#!/bin/sh

# Copyright 2020 - Dreemurrs Embedded Labs / DanctNIX Community
#
# This suspend hook is intended as a workaround for Bluetooth suspend oops:
# https://gitlab.com/pine64-org/linux/-/issues/24

prepare_suspend() {
	echo "Preparing to suspend..."
	echo serial0-0 > /sys/bus/serial/drivers/hci_uart_h5/unbind
}

resume_all() {
	echo "Resuming the device..."
	sleep 1
	echo serial0-0 > /sys/bus/serial/drivers/hci_uart_h5/bind
}

case $1 in
	pre) prepare_suspend ;;
	post) resume_all ;;
esac
