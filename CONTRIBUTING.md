Thanks for investing your time in contributing to this project! Contribution of all kinds are welcome.

This document serves as a general guide for contributing to Pine64-Arch. Follow your best judgement in following these guidelines.

## Getting Started

The [Arch Linux Wiki](https://wiki.archlinux.org) and [the project wiki](https://github.com/dreemurrs-embedded/Pine64-Arch/wiki) is a great way to get started with Arch Linux and this project in general.

## Reporting bugs

Issue reports and feature requests are encouraged.

When filing an issue, if possible, please include:

 * A clear description of the problem
 * UI that you're using on the device (like Phosh, Plasma Mobile. If the issue exists on barebone please make sure it's not your misconfiguration)
 * The application that shows the problem (if possible, attach logs as an attachment)
 * Screenshots if the issue is a visible problem

These types of focused issues are helpful:

 * UI-specific issues
 * Enhancement requests to improve user experience

Please avoid filing generic issues such as:

 * A "this program doesn't work" report (what about it doesn't work?)

## Code Guidelines

PKGBUILD contributions should follow [Arch Linux's package guidelines](https://wiki.archlinux.org/title/Arch_package_guidelines)

Each package is a commit, if one package contains multiple commits then please squash them.

If the package is forked from upstream Arch Linux/Arch Linux ARM, describe what changes are made to the package and why is it made.

Before submitting a pull request, make sure that your PKGBUILD compiles on a clean Arch Linux ARM (aarch64) root system and tested on the device/an aarch64 system.

## Commit Message Guidelines

Here is a sample commit message for a package change:

```
pkg: pine64: linux-pine64: upgrade to 5.14.9
```

 * If applicable, prefix the first line with a tag indicating the relevant area of changes:
   * `pkg:`
     * followed by which repository and package the change was made to
   * `misc:`
   * `qc:`
   * `github:`
 * Write detailed info on following lines when applicable

## Pull Requests

Pull requests are primary way to contribute to this project. Pull requests should be made against the latest `master` branch. Your pull request should not contain merges; you should always rebase when bringing the latest changes into your branch from the `master` branch. If there are merge conflicts, or if your commit history is messy, please rebase onto the latest master. [`git rebase -i`](https://thoughtbot.com/blog/git-interactive-rebase-squash-amend-rewriting-history#interactive-rebase) is a great way to clean up your pull request.

The maintainer or our developers will review your changes and try their best to helpfully suggest any changes. If all goes well, your PR should be merged without much delay.

## My pull request has been merged, what now?

We would like to thank you for your contribution. You have also contributed something to the Mobile Linux development!
