#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

export _BUILDSCR_RSYNC_HOST="${_BUILDSCR_RSYNC_HOST:-127.0.0.1}"
export _BUILDSCR_RSYNC_PORT="${_BUILDSCR_RSYNC_PORT:-22}"
export _BUILDSCR_RSYNC_USER="${_BUILDSCR_RSYNC_USER:-root}"

# TODO: Improve this?

function pkg_repo_sync_usage() {
	echo "Usage: $0 repo sync [OPTIONS] <DESTDIR>

Push current version to the remote server

Specify the following environment variable:
 - _BUILDSCR_RSYNC_HOST
 - _BUILDSCR_RSYNC_PORT
 - _BUILDSCR_RSYNC_USER

OPTIONS
    --help|-h   Show the help message"
}

function pkg_repo_sync() {
	local temp
	local destdir help_var=0 delete=0

	if ! temp=$(getopt -o 'h' -l 'help' -n 'pkgrepo_sync' -- "$@"); then
		return
	fi

	eval set -- "$temp"
	unset "$temp"

	while true; do
		case "$1" in
			'-h'|'--help')
				help_var=1
				shift
				continue
				;;
			'--')
				shift
				break
				;;
			*)
				pr_err "failed to parse options"
				return 1
				;;
		esac
	done

	if [ "$help_var" -gt 0 ]; then
		pkg_repo_sync_usage
		return 0
	fi

	destdir="$1"

	if [ -z "${destdir}" ]; then
		pr_err "You need to specify the destination/remote directory."
		return 1
	fi

	rsync_bin="$(which rsync)"
	if [ -z "${rsync_bin}" ]; then
		pr_err "failed to locate rsync"
		return 1
	fi

	pr_dbg "Rsync host: ${_BUILDSCR_RSYNC_HOST}"
	pr_dbg "Rsync port: ${_BUILDSCR_RSYNC_PORT}"
	pr_dbg "Rsync user: ${_BUILDSCR_RSYNC_USER}"
	pr_dbg "Rsync dir: ${destdir}"

	cd "$REPODIR" || return

	${rsync_bin} -e "ssh -p ${_BUILDSCR_RSYNC_PORT}" -aucP --exclude=".*" --delete . "${_BUILDSCR_RSYNC_USER}@${_BUILDSCR_RSYNC_HOST}:${destdir}" ||
		pr_err "Failed to transfer files to remote server"
}
