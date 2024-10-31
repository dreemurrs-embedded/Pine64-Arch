#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

if [ -z "$_BUILDSCR_LIB_DIR" ]; then
	return 1
fi

# shellcheck source=lib/common.bash
source "$_BUILDSCR_LIB_DIR/common.bash"

function pkg_repo_add_usage() {
	echo "Usage: $0 repo add [OPTIONS] <repository> [<package1> | <package1> <package2> ...]

Add packages to the pacman repository

OPTIONS
    --arch|-a   Architecture (aarch64, armv7h, x86_64)
    --help|-h   Show the help message"
}

function pkg_repo_add() {
	local temp
	local arch help_var=0 repo packages=()

	if ! temp=$(getopt -o 'ha:' -l 'help,arch:' -n 'pkgrepo_add' -- "$@"); then
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
		pkg_repo_add_usage
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

	repo_add_bin="$(which repo-add)"
	if [ -z "${repo_add_bin}" ]; then
		pr_err "failed to locate repo-add script"
		return 1
	fi

	if [ -z "$REPODIR" ]; then
		pr_err "REPODIR env var is not defined"
		return 1
	fi

	if [ -f "$REPODIR" ]; then
		pr_err "$REPODIR is not a directory"
		return 1
	fi

	# If repodir doesn't exist, create it.
	if [ ! -d "$REPODIR/${repo}/${arch}" ]; then
		mkdir -p "$REPODIR/${repo}/${arch}" || return

		# "any" folder contains architecture-agnostic packages
		mkdir -p "$REPODIR/${repo}/any" || return
	fi

	cp "${packages[@]}" "$REPODIR/${repo}/${arch}" || return

	cd "$REPODIR/${repo}/${arch}" || return

	for i in "${packages[@]}"; do
		local pkgarch_postprocess
		pr_dbg "Post-processing ${i}"

		pkgarch_postprocess="$(printf "%s" "${i}" | rev | cut -d '-' -f 1 | rev | cut -d '.' -f 1)"

		# if package architecture is "any", move the package to the parent "any"
		# directory and create a symlink.
		#
		# additionally, if package architecture is not our target architecture
		# then something is really wrong and we should abort it.
		if [ "${pkgarch_postprocess}" == "any" ]; then
			pr_dbg "${i} is architecture-agnostic (${pkgarch_postprocess})"

			[ ! -f "../any/${i}" ] && cp "${i}" "../any/${i}"
			rm "${i}"
			ln -s "../any/${i}" "${i}"
		elif [ "${pkgarch_postprocess}" != "${arch}" ]; then
			pr_err "Package target architecture invalid (attempting to add ${pkgarch_postprocess} package to ${arch} repo"
			return
		fi
	done

	# Remove old package after new package is added
	${repo_add_bin} -R "${repo}.db.tar.xz" "${packages[@]}" || return

	cd - || return
}
