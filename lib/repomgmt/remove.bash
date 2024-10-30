#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

if [ -z "$_BUILDSCR_LIB_DIR" ]; then
	return 1
fi

function pkg_repo_remove_usage() {
	echo "Usage: $0 repo remove [OPTIONS] <repository> [<package1> | <package1> <package2> ...]

Remove packages from the pacman repository

OPTIONS
    --arch|-a   Architecture (aarch64, armv7h, x86_64)
    --delete|-d Delete package tarball after removal
    --help|-h   Show the help message"
}

function pkg_repo_remove() {
	local temp
	local arch help_var=0 delete=0 repo packages=()

	if ! temp=$(getopt -o 'ha:d' -l 'help,arch:,delete' -n 'pkgrepo_del' -- "$@"); then
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
			'-a'|'--arch')
				arch="$2"
				shift 2
				continue
				;;
			'-d'|'--delete')
				delete=1
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
		pkg_repo_remove_usage
		return 0
	fi

	if [ -z "$arch" ]; then
		pr_err "You must specify the architecture you want to manipulate."
		return 1
	fi

	repo="$1"

	if [ -z "$repo" ]; then
		pr_err "You must specify repository name."
		return 1
	fi

	check_supported_arch "$arch" || return 1
	check_supported_repos "$repo" || return 1

	pr_dbg "Architecture: ${arch}"
	pr_dbg "Repository: ${repo}"

	for i in "${@:2}"
	do
		mapfile -t -O "${#packages[@]}" packages < <(printf "%s" "${i}")
	done

	if [ -z "${packages[0]}" ]; then
		pr_err "Please specify at least a package tarball."
		return 1
	fi

	pr_dbg "Packages: ${packages[*]}"

	repo_remove_bin="$(which repo-remove)"
	if [ -z "${repo_remove_bin}" ]; then
		pr_err "failed to locate repo-remove script"
		return 1
	fi

	cd "$REPODIR/${repo}/${arch}" || return

	${repo_remove_bin} "${repo}.db.tar.xz" "${packages[@]}" || return

	if [ "$delete" -gt 0 ]; then
		pr_warn "TODO. Manually remove the package yourself."
	fi

	cd - || return
}
