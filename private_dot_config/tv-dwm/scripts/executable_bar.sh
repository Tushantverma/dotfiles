#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/tv-dwm/scripts/bar_themes/onedark

cpu() {
  cpu_val=$(top -b -n 1 | grep "^%Cpu" | awk '{usage = $2 + $4; printf("%02.0f", usage)}')

  printf "^c$white^  ^b$black^ CPU"
  printf "^c$white^ ^b$black^ $cpu_val"
}

# pkg_updates() {
#   updates=$(checkupdates | wc -l)   # arch
#
#   if [ -z "$updates" ]; then
#     printf "  ^c$green^    Fully Updated"
#   else
#     printf "  ^c$green^    $updates"" updates"
#   fi
# }

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT*/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^  "
	printf "^c$black^^b$blue^ $(date +'%a,%d-%b %I:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  xsetroot -name "$(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)" && sleep 5 
done
