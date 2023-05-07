#!/bin/sh

#xrdb merge ~/.Xresources 
#xbacklight -set 10 &
#xset r rate 200 50 &

function run {
 if ! pgrep $1 ;
  then
    $@&
  fi
}
#run "dex $HOME/.config/autostart/arcolinux-welcome-app.desktop"
#run "xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal"
#run "xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off"
#run xrandr --output eDP-1 --primary --mode 1368x768 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off
#run xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#run xrandr --output DVI-I-0 --right-of HDMI-0 --auto
#run xrandr --output DVI-1 --right-of DVI-0 --auto
#run xrandr --output DVI-D-1 --right-of DVI-I-1 --auto
#run xrandr --output HDMI2 --right-of HDMI1 --auto
run "xrandr --output eDP-1 --mode 1600x900 --rate 58"

#autorandr horizontal

#Access there clipboard data after closing an application
#while true; do xclip -out -selection clipboard | xclip -in -selection clipboard; sleep 2; done &

#Speedy keys
xset r rate 210 40

# Don't Randomly Turn off
xset s off
xset -dpms
xset s noblank

#run "nm-applet --indicator"
#run "pamac-tray"
#run "variety"
#run "xfce4-power-manager"
#run "blueberry-tray"
#run "/usr/lib/xfce4/notifyd/xfce4-notifyd"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
picom -b  --config ~/.config/tv-dwm/picom/picom.conf &
#run "numlockx on"
#run "volumeicon"
sxhkd -c ~/.config/tv-dwm/sxhkd/sxhkdrc &
#run "nitrogen --restore"
#run "conky -c $HOME/.config/tv-dwm/conky/system-overview"
#you can set wallpapers in themes as well
#feh --bg-fill ~/Downloads/wallpaper.jpg &
#feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &
#feh --randomize --bg-fill /home/erik/Insync/Apps/Wallhaven/*
#feh --bg-fill ~/.config/tv-dwm/wallpaper/chadwm.jpg &

## if ~/.fehbg exist then run the ~/.fehbg to setup wallpaper else set the wallaper with --no-fehbg script
[[ -f ~/.fehbg ]] && . ~/.fehbg & #|| feh --no-fehbg --bg-fill ~/Downloads/wallpaper.jpg &


#nitrogen --set-zoom-fill --random /home/erik/Insync/Apps/Desktoppr/ --head=0
#nitrogen --set-zoom-fill --random /home/erik/Insync/Apps/Desktoppr/ --head=1

#wallpaper for other Arch based systems
#feh --bg-fill /usr/share/archlinux-tweak-tool/data/wallpaper/wallpaper.png &
#run applications from startup

#run "insync start"
#run "spotify"
#run "ckb-next -b"
#run "discord"
#run "telegram-desktop"
#run "dropbox"

#pkill bar.sh
#~/.config/tv-dwm/scripts/bar.sh &

pkill dwmblocks
dwmblocks &
while type chadwm >/dev/null; do chadwm && continue || break; done
