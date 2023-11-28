#!/usr/bin/env bash

# ---------------------------------------------- checkup the internet connection --------------------------------------- #
# wget -q --spider https://www.google.com || { echo "No internet connection"; exit 1; }  # wget just checks web page exist or not without downloading
# wget -q --spider https://www.google.com && { echo "Internet is working" ; } || { echo "No internet connection"; exit 1; }
wget -q --spider https://www.google.com || wget -q --spider https://www.apple.com || { echo "No internet connection"; exit 1; } && echo "Internet is working" 
# curl -s --head --fail https://www.google.com > /dev/null && { echo "Internet is working" ; } || { echo "No internet connection"; exit 1; }  # it downloads the head code to check

### install all dependency ###
sudo pacman -Sy --noconfirm --needed libx11 libxrandr cmake libxnvctrl
# libxnvctrl ==> its for nvidia but its required for working the package on the system otherwise you will have an error

[ -d "$HOME/.config/libvibrant" ] && rm -rf "$HOME/.config/libvibrant/"
git clone --depth 1 https://github.com/libvibrant/libvibrant.git "$HOME/.config/libvibrant/"
rm -rf "$HOME/.config/libvibrant"/{.git*,LICENSE,NOTICE,README.md}
mkdir "$HOME/.config/libvibrant/build/"

# Run CMake to configure the project
cmake -B "$HOME/.config/libvibrant/build/" -S "$HOME/.config/libvibrant/"
# The -B flag is used to specify the directory where CMake should generate build system files
# The -S flag is used to specify the directory containing the CMake project's CMakeLists.txt file
# you can also use ($cmake ..) in your build directory

# Build the project
make -C "$HOME/.config/libvibrant/build/"

echo "adding this command into the startup script"
display=$(xrandr --listmonitors | awk 'NR==2{print $NF}')  # getting the display name
# eDP-1 is your display port name got it form xrandr

## if the line already exist in the startup script dont add it again
if ! grep -qF "\$HOME/.config/libvibrant/build/cli/vibrant-cli"                 "$HOME/.config/startup.sh" 2>/dev/null; then
         echo "\$HOME/.config/libvibrant/build/cli/vibrant-cli $display 1.6" >> "$HOME/.config/startup.sh"
fi



# source :- https://github.com/libvibrant/libvibrant/

