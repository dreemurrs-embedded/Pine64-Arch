#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

function pkg_repo_move_usage() {
	echo "Usage: $0 repo move [OPTIONS] <SOURCE_REPO> <TARGET_REPO> [<package1> | <package1> <package2> ...]

Move packages from one pacman repository to another

OPTIONS
    --arch|-a   Architecture (aarch64, armv7h, x86_64)
    --help|-h   Show the help message"
}

function pkg_repo_move() {
	local temp
	local arch help_var=0 src_repo target_repo packages

	if ! temp=$(getopt -o 'ha:' -l 'help,arch:' -n 'pkgrepo_move' -- "$@"); then
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
		pkg_repo_move_usage
		return 0
	fi

	if [ -z "$arch" ]; then
		pr_err "You must specify the architecture you want to manipulate."
		return 1
	fi

	src_repo="$1"
	if [ -z "$src_repo" ]; then
		pr_err "You must specify source repository name."
		return 1
	fi

	target_repo="$2"
	if [ -z "$target_repo" ]; then
		pr_err "You must specify target repository name."
		return 1
	fi

	check_supported_arch "$arch" || return 1
	check_supported_repos "$src_repo" || return 1
	check_supported_repos "$target_repo" || return 1

	pr_dbg "Architecture: ${arch}"
	pr_dbg "Source repository: ${src_repo}"
	pr_dbg "Target repository: ${target_repo}"

	for i in "${@:3}"
	do
		if [ "${i}" == "all" ]; then
			mapfile -t packages < <(find "${REPODIR}/${src_repo}/${arch}" -maxdepth 1 -type f,l -iname "*.pkg.tar.*" -print0 | xargs -0 basename -a)
			break
		else
			mapfile -t -O "${#packages[@]}" packages < <(basename "${i}")
		fi
	done

	if [ -z "${packages[0]}" ]; then
		pr_err "Please specify at least a package tarball."
		return 1
	fi

	pr_dbg "Packages: ${packages[*]}"

	cd "${REPODIR}/${src_repo}/${arch}" || return

	pkg_repo_add -a "${arch}" "${target_repo}" "${packages[@]}" || return

	pkg_repo_remove -d -a "${arch}" "${src_repo}" "${packages[@]}" || return

	cd - || return
}
