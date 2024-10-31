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
	local temp temp_package_name temp_package_file temp_package_arch
	local arch help_var=0 delete=0 repo package_name=() package_file=()

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
		temp_package_file="$(basename "${i}")"
		temp_package_name="$(printf "%s" "${temp_package_file}" | rev | cut -d '-' -f 4- | rev)"
		temp_package_arch="$(printf "%s" "${temp_package_file}" | rev | cut -d '-' -f 1 | rev | cut -d '.' -f 1)"
		if [ "${temp_package_arch}" == "any" ] ; then
			mapfile -t -O "${#package_file[@]}" package_file < <(printf "%s" "../any/${temp_package_file}")
		fi
		mapfile -t -O "${#package_file[@]}" package_file < <(printf "%s" "${temp_package_file}")

		# If the signature file exists, remove it too.
		if [[ "${i}" != *".sig" ]] && [ -f "${i}.sig" ]; then
			pr_dbg "Found signature file for ${temp_package_file}"
			mapfile -t -O "${#package_file[@]}" package_file < <(printf "%s" "${temp_package_file}.sig")
		fi

		if [[ "${temp_package_file}" == *".sig" ]]; then
			pr_dbg "Skipping ${temp_package_file}"
		else
			mapfile -t -O "${#package_name[@]}" package_name < <(printf "%s" "${temp_package_name}")
		fi
	done

	if [ -z "${package_file[0]}" ]; then
		pr_err "Please specify at least a package tarball."
		return 1
	fi

	pr_dbg "Packages Files: ${package_file[*]}"
	pr_dbg "Packages Names: ${package_name[*]}"

	repo_remove_bin="$(which repo-remove)"
	if [ -z "${repo_remove_bin}" ]; then
		pr_err "failed to locate repo-remove script"
		return 1
	fi

	cd "$REPODIR/${repo}/${arch}" || return

	${repo_remove_bin} "${repo}.db.tar.xz" "${package_name[@]}" || return

	if [ "$delete" -gt 0 ]; then
		pr_info "Deleting package files.."
		rm "${package_file[@]}" || return
	fi

	cd - || return
}
