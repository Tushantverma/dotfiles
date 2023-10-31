#!/usr/bin/env bash

# run the whole script as root 
[ "$EUID" -ne 0 ] && echo "This script requires root privileges." && exec sudo sh "$0" "$@"; 

read -rep "$(tput setaf 3)show grub on boot : (yes / no): $(tput sgr0)" choice

case $choice in
    y | yes )   sed -i 's/GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=5/' /etc/default/grub ;;
    n | no  )   sed -i 's/GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=0/' /etc/default/grub ;;
    *)          echo "$(tput setaf 1)Invalid choice. Please enter either 1 or 2.$(tput sgr0)" ; exit 1 ;;
esac

grub-mkconfig -o /boot/grub/grub.cfg

echo "$(tput setaf 2)All Done$(tput sgr0)"