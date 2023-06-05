#!/bin/bash


if pacman -Qi samba &> /dev/null; then
  echo "###################################################################"
  echo "##################   Samba is installed   #########################"
  echo "###################################################################"
  exit 0  # Exit the script successfully
fi

##############################################################################################



#arcolinux pkg
sudo pacman -Sy --noconfirm --needed arcolinux-meta-samba

echo "type the password for your smb server"
sudo smbpasswd -a $USER


###############    change /etc/samba/smb.conf    ############################
# comment out the home and stoping entire home to accesable in samba
sudo sed -i '/^\[homes]/,/^$/ s/^\([^#].*\)/#\1/' /etc/samba/smb.conf

# uncomment the shared option to only share the $HOME/SHARED directory over samba
sudo sed -i '/^;\[SHARED\]/,/^;writable = yes/ { s/^;//; s/\/erik\//\/%u\// }' /etc/samba/smb.conf


mkdir $HOME/SHARED



##############################################################################################



## checking if filemanager is installed then install extra packages
## share any directory with samba by right click => properties menu
if pacman -Qi nemo &> /dev/null; then
  sudo pacman -S --noconfirm --needed nemo-share
fi
if pacman -Qi nautilus &> /dev/null; then
  sudo pacman -S --noconfirm --needed nautilus-share
fi
if pacman -Qi caja &> /dev/null; then
  sudo pacman -S --noconfirm --needed caja-share
fi
if pacman -Qi dolphin &> /dev/null; then
  sudo pacman -S --noconfirm --needed kdenetwork-filesharing
fi
if pacman -Qi thunar &> /dev/null; then
  sudo pacman -S --noconfirm --needed thunar-shares-plugin
fi



ipaddress=$(ip addr show | awk '/inet / {print $2}' | awk -F"/" 'NR==2{print $1}')

echo "samba is running on ip-address : $ipaddress"
echo "your username on samba is : $USER"
echo "password you know ;) "


echo "starting systemd deamon"
sudo systemctl start smb.service


echo "##############################################################################"
echo "##########  Reboot for Seamless Working with  thunar-shares-plugin  ##########"
echo "##############################################################################"


## systemd commands
#####################################
# sudo systemctl enable smb
# sudo systemctl disable smb
# sudo systemctl start smb
# sudo systemctl stop smb

# sudo systemctl enable --now smb
# sudo systemctl restart smb
#####################################



############################## source #################################################################################
###### this script is combination of these two steps ##########
# 1. https://arcolinux.com/how-to-install-samba-on-any-arcolinux-system/   #followed 2nd step inside the website

# 2. https://github.com/arcolinux/arcolinux-bin/tree/master/etc/skel/.bin/main/samba  
    ## followed 3rd script ## "3-install-samba-user-shares-for-every-desktop-v1.sh" to install extra plugin for file manager

############################################ some other #####
# https://youtu.be/uxSf8W_t890    # how to setup samba # arcolinux have some playlist for samba on yt
# https://arcolinux.com/samba/    # arcolinux some articals about samba
