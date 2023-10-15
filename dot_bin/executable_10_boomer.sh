#!/usr/bin/env bash

# if already exist boomer then delete it
[ -d "$HOME/.config/boomer" ] && { rm -rf "$HOME/.config/boomer" ; echo "existing directory deleted" ; }

mkdir "$HOME/.config/boomer"
git clone --depth 1 https://github.com/tsoding/boomer.git  "$HOME/.config/boomer/boomer"



# these are the dependency but they are already installed
# sudo pacman -S mesa libx11 libxext libxrandr  ## (run  dependency)
# sudo pacman -S git nimble                     ## (make dependency)

sudo pacman -Sy --noconfirm --needed nim # it's other name is nimble

	cd      "$HOME/.config/boomer/boomer/"
	nimble -y build
	mv boomer ../boomer_bin
	rm -rf "$HOME/.config/boomer/boomer/"

sudo pacman -Rcns --noconfirm nim



# adding configuration
echo '
 min_scale = 0.50
 scroll_speed = 1.5
 drag_friction = 6.0
 scale_friction = 4.0
' > "$HOME/.config/boomer/config"

# removing after install junk
rm -rf $HOME/.nimble
rm -rf $HOME/.cache/nim



# | Control                                   | Description                                                   |
# |-------------------------------------------|---------------------------------------------------------------|
# | 0                                         | Reset the application state (position, scale, velocity, etc). |
# | q or ESC                                  | Quit the application.                                         |
# | r                                         | Reload configuration.                                         |
# | Ctrl + r                                  | Reload the shaders (only for Developer mode)                  |
# | f                                         | Toggle flashlight effect.                                     |
# | Drag with left mouse button               | Move the image around.                                        |
# | Scroll wheel or =/-                       | Zoom in/out.                                                  |
# | Ctrl + Scroll wheel                       | Change the radious of the flaslight.                          |

# ./boomer_bin         # start
# ./boomer_bin --help  # because the name is changed form boomer to boomber_bin

# source : https://github.com/tsoding/boomer.git
# for more info : https://aur.archlinux.org/packages/boomer-git

