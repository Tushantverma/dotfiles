#!/usr/bin/env bash

# ---------------------------------------------- checkup the internet connection --------------------------------------- #
# wget -q --spider https://www.google.com || { echo "No internet connection"; exit 1; }  # wget just checks web page exist or not without downloading
# wget -q --spider https://www.google.com && { echo "Internet is working" ; } || { echo "No internet connection"; exit 1; }
wget -q --spider https://www.google.com || wget -q --spider https://www.apple.com || { echo "No internet connection"; exit 1; } && echo "Internet is working" 
# curl -s --head --fail https://www.google.com > /dev/null && { echo "Internet is working" ; } || { echo "No internet connection"; exit 1; }  # it downloads the head code to check

git clone --depth 1 https://github.com/jcs/xbanish.git /tmp/xbanish/

sudo make         -C /tmp/xbanish/
sudo make install -C /tmp/xbanish/
sudo make clean   -C /tmp/xbanish/

rm -rf /tmp/xbanish/

# Only add the name 'xbanish &' if it does not already exist in the file.
grep -qF "xbanish &" "$HOME/.config/startup.sh" 2>/dev/null || echo "xbanish &" >> "$HOME/.config/startup.sh"

## how to remove it 
#1 remove form "$HOME/.config/startup.sh"
#2 sudo rm -rf /usr/local/bin/xbanish (remove binary)
#3 sudo rm -rf /usr/local/man/man1/xbanish.1 (remove manpage)

## alternative tool
# sudo pacman -Sy --needed --noconfirm unclutter
# echo "unclutter -idle 2 & " >> $HOME/.config/startup.sh

