#!/bin/bash

sudo pacman -Sy --noconfirm --needed snapper btrfs-assistant

sudo mkdir /.snapshots/1
sudo btrfs subvolume create /.snapshots/1/snapshot


NOW=$(date +"%Y-%m-%d %H:%M:%S")

sudo echo "
<?xml version="1.0"?>
<snapshot>
	<type>single</type>
	<num>1</num>
	<date>$NOW</date>
	<description>First Root Filesystem Created at Installation</description>
</snapshot>

" > /.snapshots/1/info.xml

sudo btrfs subvolume set-default $(btrfs subvolume list /mnt | grep "@/.snapshots/1/snapshot" | grep -oP '(?<=ID )[0-9]+') /




sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper --no-dbus -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
sudo grub-mkconfig -o /boot/grub/grub.cfg











# sudo umount /.snapshots
# sudo rm -r /.snapshots
# sudo snapper --no-dbus -c root create-config /
# sudo btrfs subvolume delete /.snapshots
# sudo mkdir /.snapshots
# sudo mount -a
# sudo chmod 750 /.snapshots

# sudo grub-mkconfig -o /boot/grub/grub.cfg




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
