#!/bin/bash

git clone --depth=1 https://github.com/jcs/xbanish.git
cd xbanish/
sudo make; sudo make install; sudo make clean;
cd ..
rm -rf xbanish/
echo "xbanish &" >> ~/.startup.sh

## how to remove it 
#1 remove form ~/.startup.sh
#2 sudo rm -rf /usr/local/bin/xbanish (remove binary)
#3 sudo rm -rf /usr/local/man/man1/xbanish.1 (remove manpage)