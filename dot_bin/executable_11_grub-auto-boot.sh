#!/usr/bin/env bash

# run the whole script as root 
[ "$EUID" -ne 0 ] && echo "This script requires root privileges." && exec sudo sh "$0" "$@"; 

read -rep "$(tput setaf 3)Grub on boot : [ (e)nable / (d)isable ]: $(tput sgr0)" choice

case $choice in
    e | enable )   sed -i 's/GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=5/' /etc/default/grub && echo "$(tput setaf 2)Enabled $(tput sgr0)";;
    d | disable)   sed -i 's/GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=0/' /etc/default/grub && echo "$(tput setaf 2)Disabled$(tput sgr0)";;
    *)  echo "$(tput setaf 1)Invalid choice. Please enter [(e)nable / (d)isable] $(tput sgr0)" ; exit 1 ;;
esac

grub-mkconfig -o /boot/grub/grub.cfg
