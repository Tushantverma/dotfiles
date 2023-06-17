#!/bin/bash

su ; cd /
pacman -Sy --noconfirm --needed snapper btrfs-assistant

umount /.snapshots
rm -r /.snapshots
snapper --no-dbus -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
chmod 750 /.snapshots

grub-mkconfig -o /boot/grub/grub.cfg









































###################### look after ########################################################
# #Changing The timeline auto-snap
# sed -i 's|QGROUP=""|QGROUP="1/0"|' /etc/snapper/configs/root
# sed -i 's|NUMBER_LIMIT="50"|NUMBER_LIMIT="5-15"|' /etc/snapper/configs/root
# sed -i 's|NUMBER_LIMIT_IMPORTANT="50"|NUMBER_LIMIT_IMPORTANT="5-10"|' /etc/snapper/configs/root
# sed -i 's|TIMELINE_LIMIT_HOURLY="10"|TIMELINE_LIMIT_HOURLY="2"|' /etc/snapper/configs/root
# sed -i 's|TIMELINE_LIMIT_DAILY="10"|TIMELINE_LIMIT_DAILY="2"|' /etc/snapper/configs/root
# sed -i 's|TIMELINE_LIMIT_WEEKLY="0"|TIMELINE_LIMIT_WEEKLY="2"|' /etc/snapper/configs/root
# sed -i 's|TIMELINE_LIMIT_MONTHLY="10"|TIMELINE_LIMIT_MONTHLY="0"|' /etc/snapper/configs/root
# sed -i 's|TIMELINE_LIMIT_YEARLY="10"|TIMELINE_LIMIT_YEARLY="0"|' /etc/snapper/configs/root


# #activating the auto-cleanup
# SCRUB=$(systemd-escape --template btrfs-scrub@.timer --path /dev/disk/by-uuid/${ROOTUUID})
# systemctl enable ${SCRUB}
# systemctl enable snapper-timeline.timer
# systemctl enable snapper-cleanup.timer
