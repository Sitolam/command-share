#!/bin/bash
sed -i 's/HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck)/HOOKS=(base udev block modconf kms keyboard keymap consolefont autodetect filesystems fsck)/g' /etc/mkinitcpio.conf
