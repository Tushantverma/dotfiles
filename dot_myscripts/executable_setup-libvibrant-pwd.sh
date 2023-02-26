#!/bin/bash

# cd into the directory first where you want to place this script files

### install all dependency
sudo pacman -Sy --noconfirm --needed libx11 libxrandr libxnvctrl cmake
# libxnvctrl ==> not installing right now this is for nvedia


cd ~/.config/

# delete old file is there is any
rm -rf libvibrant

git clone --depth 1 https://github.com/libvibrant/libvibrant.git

cd libvibrant
rm -rf .git*
mkdir build
cd build
cmake ..
make

echo "add this command into the startup script"

# getting the display name
display=$(xrandr --listmonitors | awk 'NR==2{print $NF}')
echo "$PWD/vibrant-cli/vibrant-cli $display 1.6" >> ~/.startup.sh
# eDP-1 is your display port name find it form xrandr




# source :- https://github.com/libvibrant/libvibrant/
