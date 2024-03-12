#!/bin/bash

# my OS install script will use '*'

echo "my User is : $USER"
echo "my Home is : $HOME"
 
# building dwm
cd /home/$USER/.config/tv-dwm/chadwm/
sudo make
sudo make install
sudo make clean

# building st
cd /home/$USER/.config/tv-dwm/st/
sudo make
sudo make install
sudo make clean

# building dwmblocks
cd /home/$USER/.config/tv-dwm/dwmblocks/
sudo make
sudo make install
sudo make clean
