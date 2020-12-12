#!/bin/bash

# Copyright 2020 - Dreemurrs Embedded Labs / DanctNIX Community

prepare_suspend() {
	echo "Preparing to suspend..."
}

resume_all() {
	echo "Resuming the device..."
	hwclock -s &
}

case $1 in
	pre) prepare_suspend ;;
	post) resume_all ;;
esac
