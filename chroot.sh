#!/bin/bash

cryptsetup open /dev/sda2 gentooRoot

echo "Unlocked"
sleep 2

mount /dev/mapper/gentoo-root /mnt/gentoo

mount -v -t proc none /mnt/gentoo/proc
mount -v --rbind /dev /mnt/gentoo/dev
mount -v --rbind /run /mnt/gentoo/run
mount -v --rbind /sys /mnt/gentoo/sys
mount -v --make-rslave /mnt/gentoo/dev
mount -v --make-rslave /mnt/gentoo/run
mount -v --make-rslave /mnt/gentoo/sys
chroot /mnt/gentoo /bin/bash
