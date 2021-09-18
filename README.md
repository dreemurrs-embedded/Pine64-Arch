# Arch Linux ARM on Mobile

This repository contains PKGBUILDS that makes Arch Linux ARM runs on mobile.

Currently only supports PinePhone and PineTab. Images for these can be found [here](https://github.com/dreemurrs-embedded/Pine64-Arch/releases).

User login details

    User: alarm
    Pass: 123456

NOTE: SSH is disabled for security, for more information on how to enable please read [this](https://github.com/dreemurrs-embedded/Pine64-Arch/wiki/SSH).


# Barebone Image Quick Start

After your phone booted with the barebone image, you should see a TTY login prompt.
Login to your system

There are two ways to take control of the device:
### USB Keyboard + USB OTG / Convergence Dock

You can either attach a USB keyboard to your device via a USB-OTG cable or the convergence dock. This allows you to login to your device like a normal computer and do whatever you want.

Login credentials:

    root: root
    alarm: 123456

This will not work on a non-fixed Braveheart/UBports Edition device or non-flashed ANX7688 controller.
From a computer

If you do not have a USB keyboard or a OTG cable, you can plug the device to a computer, now you should see a new network interface on your computer.

If you do not have a SSH client:

    Windows: https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
    macOS/Linux: Open Terminal -> ssh

Now SSH to alarm@10.15.19.82, the password is 123456.

## Come and talk with us!
 * Matrix: #archmobile:kde.org
 * Telegram: @archlinux_pinephone
