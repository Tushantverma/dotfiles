#!/bin/bash

echo "###########################################################################"
echo "##      Check which kernal is installed            					   ##"
echo "###########################################################################"

kernel=$(uname -r)

case $kernel in
    *-lts*)
        echo "Linux LTS kernel is installed."
        installpkg="linux-lts linux-lts-headers"
        ;;
    *-hardened*)
        echo "Linux Hardened kernel is installed."
        installpkg="linux-hardened linux-hardened-headers"
        ;;
    *-zen*)
        echo "Linux Zen kernel is installed."
        installpkg="linux-zen linux-zen-headers"
        ;;
    *)
        echo "Standard Linux kernel is installed."
        installpkg="linux linux-headers"
        ;;
esac


echo "###########################################################################"
echo "##              This script will install virtualbox                      ##"
echo "###########################################################################"

sudo pacman -Syyy
sudo pacman -S --noconfirm --needed $(echo $installpkg) ## Installing headers and updating kernal in a single variable (solving this error "Kernel driver not installed (rc=-1908)" by updating kernal)
sudo pacman -S --noconfirm --needed virtualbox
sudo pacman -S --noconfirm --needed virtualbox-host-dkms
sudo pacman -S --noconfirm --needed xdotool  ## auto type from clipboard

echo "###########################################################################"
echo "##      Removing all the messages virtualbox produces                    ##"
echo "###########################################################################"
VBoxManage setextradata global GUI/SuppressMessages "all"


echo "###########################################################################"
echo "#########               You have to reboot.                       #########"
echo "###########################################################################"


## source
## https://github.com/erikdubois/arcolinux-nemesis/tree/master/AUR
## combined multiple virtual box install script into one main
