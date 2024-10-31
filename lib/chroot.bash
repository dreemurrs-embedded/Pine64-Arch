#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

if [ -z "$_BUILDSCR_LIB_DIR" ]; then
	return 1
fi

# shellcheck source=lib/common.bash
source "$_BUILDSCR_LIB_DIR/common.bash"

function chrootcmd_create() {
	# $1: repo (danctnix, danctnix-testing, danctnix-staging)
	# $2: architecture (armv7h, aarch64, x86_64)
	local arch repo packages

	arch="$2"
	repo="$1"

	if [ -z "$arch" ] && [ -z "$repo" ]; then
		return 255
	fi

	mkarchroot_bin="$(which mkarchroot)"
	if [ -z "$mkarchroot_bin" ]; then
		pr_err "failed to locate mkarchroot script"
		return 1
	fi

	packages=(base-devel)

	if [ -z "${_BUILDSCR_MISC_DIR}" ]; then
		pr_err "failed to locate misc directory"
		return 1
	fi

	if [ -z "${_BUILDSCR_CHROOT_DIR}" ]; then
		pr_err "failed to locate chroots directory"
		return 1
	fi

	if [ ! -f "${_BUILDSCR_MISC_DIR}/pacman.conf.d/${repo}-${arch}.conf" ]; then
		pr_err "failed to locate pacman config"
		return 1
	fi
	
	if [ ! -f "${_BUILDSCR_MISC_DIR}/makepkg.conf.d/${arch}.conf" ]; then
		pr_err "failed to locate makepkg config"
		return 1
	fi

	${SUDO} mkdir -p "${_BUILDSCR_CHROOT_DIR}/${repo}-${arch}" || return

	pr_warn "As of pacman 7.x, pacman no longer runs as root."
	pr_warn
	pr_warn "Instead, pacman now deescalate to user 'alpm' by default."
	pr_warn "If mkarchroot fails, you need to change directory's ownership to user and group 'alpm'."

	${mkarchroot_bin} \
		-C "${_BUILDSCR_MISC_DIR}/pacman.conf.d/${repo}-${arch}.conf" \
		-M "${_BUILDSCR_MISC_DIR}/makepkg.conf.d/${arch}.conf" \
		-s "${_BUILDSCR_CHROOT_DIR}/${repo}-${arch}/root" \
		"${packages[@]}" || pr_err "Error occurred when creating chroot."
}

function chrootcmd_run() {
	# $1: repo (danctnix, danctnix-testing, danctnix-staging)
	# $2: architecture (armv7h, aarch64, x86_64)
	# $3: use base chroot?
	# ${@:4}: sd-nspawn arguments
	local arch repo chroot_user

	arch="$2"
	repo="$1"

	if [ -z "$arch" ] && [ -z "$repo" ]; then
		return 255
	fi

	archnspawn_bin="$(which arch-nspawn)"
	if [ -z "$archnspawn_bin" ]; then
		pr_err "failed to locate arch-nspawn script"
		return 1
	fi

	if [ -z "${_BUILDSCR_CHROOT_DIR}" ]; then
		pr_err "failed to locate chroots directory"
		return 1
	fi

	if [ -z "${_BUILDSCR_MISC_DIR}" ]; then
		pr_err "failed to locate misc directory"
		return 1
	fi

	if [ "$3" -ne 0 ]; then
		chroot_user=root
	else
		chroot_user=$USER
	fi

	pr_dbg "${_BUILDSCR_CHROOT_DIR}/${repo}-${arch}/${chroot_user}"
	if [ ! -d "${_BUILDSCR_CHROOT_DIR}/${repo}-${arch}/${chroot_user}" ]; then
		pr_err "failed to locate chroot (not initialized?)"
		return 1
	fi

	# shellcheck disable=SC2068
	${archnspawn_bin} \
		-C "${_BUILDSCR_MISC_DIR}/pacman.conf.d/${repo}-${arch}.conf" \
		-M "${_BUILDSCR_MISC_DIR}/makepkg.conf.d/${arch}.conf" \
		-s "${_BUILDSCR_CHROOT_DIR}/${repo}-${arch}/${chroot_user}" \
		${@:4}
}


function chrootcmd_usage() {
	echo "Usage: $0 chroot [COMMAND] [OPTIONS] -- [CHROOT_COMMAND]

Manage build chroot

COMMANDS
    create    Create a new chroot (for new configurations)
    shell     Spawn a shell inside the chroot

OPTIONS
    --arch|-a         Architecture (aarch64, armv7h, x86_64)
    --repo|-r         Repository (danctnix, danctnix-testing, danctnix-staging)
    --use-base-chroot Use base chroot instead of cloned chroot"
}

function chrootcmd() {
	local tmpgetopt

	local chosencmd=0

	# options
	local arch repo commands use_base_chroot=0

	case "$1" in
		'create')
			chosencmd=1
			;;
		'shell')
			chosencmd=2
			;;
		*)
			chrootcmd_usage
			return 1
		;;
	esac

	if ! tmpgetopt=$(getopt -o 'a:r:' -l 'arch:,repo:,use-base-chroot' -n "chrootcmd" -- "$@"); then
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
			'--use-base-chroot')
				use_base_chroot=1
				shift
				continue
			;;
			'--')
				commands="${*:3}"
				shift
				break
			;;
			*)
				pr_err "failed to parse options"
				return 1
			;;
		esac
	done


	if [ -z "$arch" ]; then
		pr_err "You must specify an architecture."
		chrootcmd_usage
		return 1
	elif [ -z "$repo" ]; then
		pr_err "You must specify a repository."
		chrootcmd_usage
		return 1
	fi

	check_supported_arch "$arch" || return 1
	check_supported_repos "$repo" || return 1

	pr_dbg "Architecture: ${arch}"
	pr_dbg "Repository: ${repo}"
	pr_dbg "Use Base Chroot: ${use_base_chroot}"
	pr_dbg "Command: ${commands}"

	case "$chosencmd" in
		1)
			chrootcmd_create "$repo" "$arch"
			return
			;;
		2)
			chrootcmd_run "$repo" "$arch" "$use_base_chroot" "${commands[@]}"
			return
			;;
		*)
			pr_err "Unknown command"
			return
			;;
	esac

}
