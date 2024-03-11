#!/bin/bash

# my OS install script will use '*'

echo "my home is $HOME"
echo "my user is $USER"

# building dwm
cd /home/*/.config/tv-dwm/chadwm/
sudo make
sudo make install
sudo make clean

# building st
cd /home/*/.config/tv-dwm/st/
sudo make
sudo make install
sudo make clean

# building dwmblocks
cd /home/*/.config/tv-dwm/dwmblocks/
sudo make
sudo make install
sudo make clean
