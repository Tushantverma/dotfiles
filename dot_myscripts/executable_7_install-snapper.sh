#!/bin/bash

# run the whole script as root 
[ "$EUID" -ne 0 ] && echo "This script requires root privileges." && exec sudo sh "$0" "$@"; 


#-----------------------------------  Setting up @.Snapshots subvolume --------------------------------------#

# Check if the @.snapshots subvolume dosen't exists then execute billow code
if ! sudo btrfs subvolume list / | grep -q '@.snapshots'; then       

tput setaf 2; tput bold;   # color dark blue
echo "creating @.snapshots because it dosen't exist"
tput sgr0                  # color reset

# if this directory dosen't exist then create it
[ ! -d "/.snapshots" ] && mkdir /.snapshots

# creating top level 5 subvolume
current_disk_partition=$(df --output=source / | tail -1) # /dev/sdX#
mount $current_disk_partition /.snapshots
btrfs subvolume create /.snapshots/@.snapshots 
umount /.snapshots

# mount subvolume on current system
mountpoint="rw,noatime,compress=zstd:3,discard=async,space_cache=v2,autodefrag,commit=120"
mount -o "$mountpoint","subvol=/@.snapshots"   $current_disk_partition /.snapshots

# add mount entery in fstab to automatically mount @.snapshots after boot
myUUID=$(blkid $current_disk_partition -s UUID -o value)

echo "# $current_disk_partition
UUID=$myUUID	/.snapshots	btrfs     	$mountpoint,subvol=/@.snapshots	0 0" >> /etc/fstab

fi
#------------------------------------------------------------------------------------------------------------#


pacman -Sy --noconfirm --needed snapper btrfs-assistant

mkdir /.snapshots/1
btrfs subvolume create /.snapshots/1/snapshot


NOW=$(date +"%Y-%m-%d %H:%M:%S")


# setup first dummy snapshot #
################ every little space + new_line dose matter otherwise your first snapshot will not be created there ####################
echo "<?xml version=\"1.0\"?>
<snapshot>
	<type>single</type>
	<num>1</num>
	<date>$NOW</date>
	<description>First Root Filesystem Created at Installation</description>
</snapshot> " > /.snapshots/1/info.xml
########################################################################################################################################

# set the default subvolume
btrfs subvolume set-default $(btrfs su li / | grep @.snapshots/1/snapshot | grep -oP '(?<=ID )[0-9]+') /


# setting up snapper
umount /.snapshots
rm -r /.snapshots
snapper --no-dbus -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a  ## this will mount only those entery which is configured in /etc/fstab
chmod 750 /.snapshots
grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null & #to update grub-btrfs (grub snapshot menu)











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
