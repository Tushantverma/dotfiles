#!/bin/bash

# building dwm
cd ~/.config/tv-dwm/chadwm/
sudo make
sudo make install
sudo make clean

# building st
cd ~/.config/tv-dwm/st/
sudo make
sudo make install
sudo make clean

