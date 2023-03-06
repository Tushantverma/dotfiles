#!/bin/bash

# my OS install script will use '*'

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

