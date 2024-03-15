#!/bin/bash

# $username is comming from OS installation script
# if $username not set, _USER will fallback to $USER
_USER="${username:-$USER}"
_HOME="$(getent passwd "$_USER" | cut -d: -f6)"

# building dwm
cd /home/$_USER/.config/tv-dwm/chadwm/
sudo make
sudo make install
sudo make clean

# building st
cd /home/$_USER/.config/tv-dwm/st/
sudo make
sudo make install
sudo make clean

# building dwmblocks
cd /home/$_USER/.config/tv-dwm/dwmblocks/
sudo make
sudo make install
sudo make clean
