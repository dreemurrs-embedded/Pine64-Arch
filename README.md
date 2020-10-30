# Arch Linux ARM for PinePhone/PineTab

This repository contains PKGBUILDs for running ALARM on the PinePhone/PineTab.

Compiled rootfs images can be found in "[Releases](https://github.com/dreemurrs-embedded/Pine64-Arch/releases)"

## Flashing images
You can use dd, etcher, or win32diskimager.  

Example using dd on a mac-- your disk may vary, always be careful using dd:

```bash
 xz -d archlinux-pinephone-phosh-20200822.img.xz
 sudo dd if=archlinux-pinephone-phosh-20200822.img of=/dev/disk2
 ```
 
 To write to emmc, turn your pinephone off, then hold the volume button up and the power button until you see "install upgrade" and a lil robot-guy.  Then you can connect your pinephone to your computer and flash it with whatever method you'd like.  

## Come talk to us!
 * Discord: https://discord.gg/AvtdRJ3 (#archlinux-pinephone)
 * Matrix: #archlinux-pinephone:kde.org
 * Telegram: @archlinux_pinephone
