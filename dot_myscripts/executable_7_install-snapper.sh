#!/bin/bash

# run the whole script as root 
[ "$EUID" -ne 0 ] && echo "This script requires root privileges." && exec sudo sh "$0" "$@"; 


pacman -Sy --noconfirm --needed snapper btrfs-assistant

mkdir /.snapshots/1
btrfs subvolume create /.snapshots/1/snapshot


NOW=$(date +"%Y-%m-%d %H:%M:%S")


# setup first dummy snapshot
echo -n"
<?xml version=\"1.0\"?>
<snapshot>
	<type>single</type>
	<num>1</num>
	<date>$NOW</date>
	<description>First Root Filesystem Created at Installation</description>
</snapshot> " > /.snapshots/1/info.xml


# set the default subvolume
btrfs subvolume set-default $(btrfs su li / | grep @.snapshots/1/snapshot | grep -oP '(?<=ID )[0-9]+') /


# setting up snapper
umount /.snapshots
rm -r /.snapshots
snapper --no-dbus -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
chmod 750 /.snapshots
sleep 1
grub-mkconfig -o /boot/grub/grub.cfg











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
