#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

if [ -z "$_BUILDSCR_LIB_DIR" ]; then
	echo "Do not run this script directly."
	return 1
fi

# shellcheck source=lib/loglevel.bash
source "$_BUILDSCR_LIB_DIR/loglevel.bash"

# shellcheck source=lib/supportlist.bash
source "$_BUILDSCR_LIB_DIR/supportlist.bash"

function check_supported_arch() {
	local arch="$1"

	for i in "${SUPPORTED_ARCHES[@]}"
	do
		if [ "$arch" == "${i}" ]; then
			return 0
		fi
	done

	pr_err "${arch} is not supported."
	return 1
}

function check_supported_repos() {
	local repo="$1"

	for i in "${SUPPORTED_REPOS[@]}"
	do
		if [ "$repo" == "${i}" ]; then
			return 0
		fi
	done

	pr_err "This repository (${repo}) is not supported. Is it a typo?"
	return 1
}
