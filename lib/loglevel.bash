#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

function pr_info() {
	printf "INFO: %s\n" "$1"
}

function pr_warn() {
	printf "\033[0;33mWARN: %s\033[0m\n" "$1"
}

function pr_err() {
	printf "\033[0;31mERROR: %s\033[0m\n" "$1" >&2
}

function pr_dbg() {
	[ "$_BUILDSCR_DEBUG" ] && printf "DEBUG: %s\n" "$1"
}
