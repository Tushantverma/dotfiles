#!/bin/bash
# create this script again by looking on internet and understand everything
# create another script if it didn't work as expected

# other tutorials
#tutorial https://www.youtube.com/watch?v=JxSGT_3UU8w
#https://computingforgeeks.com/install-kvm-qemu-virt-manager-arch-manjar/

sudo pacman -S --noconfirm --needed iptables
sudo pacman -S --noconfirm --needed ebtables 

sudo pacman -S --noconfirm --needed qemu-full
sudo pacman -S --noconfirm --needed virt-manager
sudo pacman -S --noconfirm --needed virt-viewer
sudo pacman -S --noconfirm --needed dnsmasq
sudo pacman -S --noconfirm --needed vde2
sudo pacman -S --noconfirm --needed bridge-utils
#ovmf
sudo pacman -S --noconfirm --needed edk2-ovmf

#sudo pacman -S --noconfirm --needed spice-vdagent 
#sudo pacman -S --noconfirm --needed xf86-video-qxl

sudo pacman -S --noconfirm --needed dmidecode

#starting service

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

# enables virtual machine inside virtual machine
# echo -e "options kvm-intel nested=1" | sudo tee -a /etc/modprobe.d/kvm-intel.conf

user=$(whoami)
sudo gpasswd -a $user libvirt
sudo gpasswd -a $user kvm


echo '
nvram = [
    "/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"
]' | sudo tee --append /etc/libvirt/qemu.conf

sudo virsh net-define /etc/libvirt/qemu/networks/default.xml

sudo virsh net-autostart default

sudo systemctl restart libvirtd.service

echo "############################################################################################################"
echo "#####################                        FIRST REBOOT                              #####################"
echo "############################################################################################################"

## source
## https://github.com/erikdubois/arcolinux-nemesis/tree/master/AUR

# othe way to setup qemu on archl : https://christitus.com/setup-qemu-in-archlinux/
#=================================: https://linuxhint.com/install_configure_kvm_archlinux/#sidr-main
