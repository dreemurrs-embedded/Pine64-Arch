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
	pr_err "TODO. Manually move the package for now."
	return 
}
