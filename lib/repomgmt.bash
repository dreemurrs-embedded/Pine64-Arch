#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

if [ -z "$_BUILDSCR_LIB_DIR" ]; then
	return 1
fi

# shellcheck source=lib/repomgmt/add.bash
source "$_BUILDSCR_LIB_DIR/repomgmt/add.bash"

# shellcheck source=lib/repomgmt/move.bash
source "$_BUILDSCR_LIB_DIR/repomgmt/move.bash"

# shellcheck source=lib/repomgmt/remove.bash
source "$_BUILDSCR_LIB_DIR/repomgmt/remove.bash"

# shellcheck source=lib/repomgmt/sync.bash
source "$_BUILDSCR_LIB_DIR/repomgmt/sync.bash"

function pkg_repo_usage() {
	echo "Usage: $0 repo [COMMAND] [OPTIONS] [<package1> | <package1> <package2> ...]

Manipulate repository data

COMMANDS
    add       Add one or more package to the repository
    remove    Remove one or more package from the repository
    move      Move package from one repository to another
    sync      Push current version to the remote server"
}

function repomgmt() {
	case "$1" in
		'add')
			pkg_repo_add "${@:2}"
			return
			;;
		'remove')
			pkg_repo_remove "${@:2}"
			return
			;;
		'move')
			pkg_repo_move "${@:2}"
			return
			;;
		'sync')
			pkg_repo_sync "${@:2}"
			return
			;;
		*)
			pkg_repo_usage
			return 255
			;;
	esac
}
