#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 - The DanctNIX Contributors

if [ "$(id -u)" == 0 ]; then
	echo "Do not run this script as root."
	exit 1
fi

BASESCRIPT="$(realpath "$0")"
BASEPATH="$(dirname "$BASESCRIPT")"

_BUILDSCR_CHROOT_DIR="${_BUILDSCR_CHROOT_DIR:-/var/lib/danctnix-chroots}"
_BUILDSCR_LIB_DIR="$BASEPATH/lib"
_BUILDSCR_MISC_DIR="$BASEPATH/misc"

# shellcheck source=lib/mkpkg.bash
source "$_BUILDSCR_LIB_DIR/mkpkg.bash"

# shellcheck source=lib/repomgmt.bash
source "$_BUILDSCR_LIB_DIR/repomgmt.bash"

# shellcheck source=lib/loglevel.bash
source "$_BUILDSCR_LIB_DIR/loglevel.bash"

# shellcheck source=lib/chroot.bash
source "$_BUILDSCR_LIB_DIR/chroot.bash"

export REPODIR="${REPODIR:-$BASEPATH/repo}"
export SRCDEST="${SRCDEST:-$BASEPATH/sources}"
export SRCPKGDEST="${SRCPKGDEST:-$BASEPATH/sources/srcpkg}"
export LOGDEST="${LOGDEST:-$BASEPATH/logs}"

# HACK: We don't need to run setarch.
export nosetarch=1

SUDO=

if ! SUDO=$(which sudo); then
	pr_err "Can't find sudo. If you're using doas, there may be an alias package available."
	exit 1
fi

if [ "$BASEPATH" != "$(pwd)" ]; then
	pr_err "You must run this script inside it's own directory ($BASEPATH)."
	exit 1
fi

build_script_usage() {
	echo "Usage: $0 [COMMAND] [OPTIONS]

Command line tool for DanctNIX maintainers.

COMMANDS
    build   Build package in a clean chroot
    chroot  Manage chroot
    repo    Manipulate repository data
"

}

# Check if we're running Arch Linux or Arch Linux ARM.
#
# This should be removed in the future when we can figure out how
# to support non-Arch based distros.
OSREL_ID=$(grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"')
if [[ ! "$OSREL_ID" =~ "arch" ]]; then
	pr_warn "You're not running Arch Linux. This is not supported and you may encounter weird issues."
fi

case "$1" in
	build)
		pkg_build "${@:2}"
		;;
	chroot)
		chrootcmd "${@:2}"
		;;
	repo)
		repomgmt "${@:2}"
		;;
	*)
		build_script_usage
		;;
esac
