#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

if [ -z "$_BUILDSCR_LIB_DIR" ]; then
	return 1
fi

# shellcheck source=lib/common.bash
source "$_BUILDSCR_LIB_DIR/common.bash"

function mkpkg() {
	# $1: repo (danctnix, danctnix-testing, danctnix-staging)
	# $2: architecture (armv7h, aarch64, x86_64)
	# ${@:3}: package path

	local chroot_location arch repo pkgfiles=() pkgfiles_gpg=()

	arch="$2"
	repo="$1"

	if [ -z "${arch}" ] && [ -z "${repo}" ]; then
		return 255
	fi

	makechrootpkg_bin="$(which makechrootpkg)"
	if [ -z "$makechrootpkg_bin" ]; then
		pr_err "Cannot find makechrootpkg script"
		return 1
	fi
	pr_dbg "makechrootpkg is at ${makechrootpkg_bin}"

	makepkg_bin="$(which makepkg)"
	if [ -z "$makepkg_bin" ]; then
		pr_err "Cannot find makepkg script"
		return 1
	fi
	pr_dbg "makepkg is at ${makepkg_bin}"

	if [ -z "${_BUILDSCR_CHROOT_DIR}" ]; then
		pr_err "failed to locate chroots directory"
		return 1
	fi

	chroot_location="${_BUILDSCR_CHROOT_DIR}/${repo}-${arch}"
	pr_dbg "Chroot location: ${chroot_location}"

	# we run setarch with a true command to see if it
	# returns an error.
	#
	# if it does, we'll add an architecture alias to devtools
	# so whenever devtools needs it, it won't fail.
	if [ ! -f "/usr/share/devtools/setarch-aliases.d/${arch}" ] &&
		! setarch "${arch}" /bin/true; then
		pr_info "Creating a setarch alias for ${arch}"

		local arch_check
		arch_check="$(uname -m)"
		printf "%s\n" "${arch_check}" |
			${SUDO} tee "/usr/share/devtools/setarch-aliases.d/${arch}" > /dev/null
	fi

	for i in "${@:3}"; do 
		if ! cd "${i}"; then
			pr_err "Cannot enter ${i}"
			continue
		fi

		if ! $makechrootpkg_bin -r "${chroot_location}" -C -n -c -u -x failure; then
			# No need to let the user knows build failed twice.
			# makechrootpkg already covered it.
			continue
		fi

		${makepkg_bin} --printsrcinfo > .SRCINFO

		mapfile -t pkgfiles < <(${makepkg_bin} --packagelist)

		if [ -n "${_BUILDSCR_GPG_KEY}" ]; then
			local gpg_bin
			gpg_bin="$(which gpg)"

			if [ -z "${gpg_bin}" ]; then
				pr_err "GPG binary not found"
				return
			fi

			for pkgfile in "${pkgfiles[@]}"; do
				${gpg_bin} -u "${_BUILDSCR_GPG_KEY}" --output "${pkgfile}.sig" --detach-sig "${pkgfile}"
				${gpg_bin} --verify "${pkgfile}.sig" "${pkgfile}"
				pkgfiles_gpg+=( "${pkgfile}.sig" )
			done
		fi

		pkg_repo_add -a "${arch}" "${repo}" "${pkgfiles[@]}"
		rm "${pkgfiles[@]}" "${pkgfiles_gpg[@]}"
	done
}

function pkg_build_usage() {
	echo "Usage: $0 build [OPTIONS] [<package1> | <package1> <package2> ...]

Build package in a clean chroot

OPTIONS
    --arch|-a    Architecture (aarch64, armv7h, x86_64)
    --repo|-r    Repository (danctnix, danctnix-testing, danctnix-staging)"
}

function pkg_build() {
	local tmpgetopt

	# options
	local arch repo packages=()

	if [ "$#" -lt 3 ]; then
		pkg_build_usage
		return 1
	fi

	tmpgetopt=$(getopt -o 'a:r:' -l 'arch:,repo:' -n "pkg_build" -- "$@")
	# shellcheck disable=SC2181
	if [ $? -ne 0 ]; then
		return 1
	fi

	eval set -- "$tmpgetopt"

	while true; do
		case "$1" in
			'-a'|'--arch')
				arch="$2"
				shift 2
				continue
			;;
			'-r'|'--repo')
				repo="$2"
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

	check_supported_arch "$arch" || return 1
	check_supported_repos "$repo" || return 1

	for i in "${@:1}"; do
		mapfile -t -O "${#packages[@]}" packages < <(realpath "${i}")
	done

	if [ -z "${packages[0]}" ]; then
		pr_err "No packages specified"
		return 1
	fi

	mkpkg "$repo" "$arch" "${packages[@]}"
}
