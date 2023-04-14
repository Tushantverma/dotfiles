#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color
# ^d^ =  clear color

interval=0

# load colors
#. ~/.config/tv-dwm/scripts/bar_themes/onedark

black=#1e222a
green=#7eca9c
white=#f5f58e
grey=#282c34
blue=#7aa2f7
red=#d47d85
darkblue=#668ee3
orange=#f5f58e
cyne=#f5f58e
pink=#f5f58e
purple=#bd93f9   ##good color

cpu() {
  cpu_val=$(top -b -n 1 | grep "^%Cpu" | awk '{usage = $2 + $4; printf("%02.0f", usage)}')
  printf "^c$white^   $cpu_val^d^"
}


mem() {
  printf "^c$orange^   $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)^d^"
}


clock() {
	printf "^c$black^ ^b$darkblue^  "
	printf "^c$black^^b$blue^ $(date +'%a,%d-%b %I:%M') "
}


get_volume() {
  VALUE=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '/^Volume/ { print substr($5, 1, length($5)-1) }')

  if [ "$(pactl get-sink-mute @DEFAULT_SINK@)" = "Mute: yes" ]; then
    ICON="婢"
  else
    if [ $VALUE -lt 30 ]; then
      ICON="奄"
    else
      if [ $VALUE -lt 60 ]; then
        ICON="奔"
      else
        ICON="墳"
      fi
    fi
  fi

  if [ "$(pactl get-source-mute @DEFAULT_SOURCE@)" = "Mute: yes" ]; then
    MIC=""
  else
    MIC=" "
  fi

  echo "^c$cyne^$MIC$ICON $VALUE%^d^"
}


function get_brightness {
  echo "^c$pink^盛 $(printf "%.0f\n" $(light))%^d^"
}


function get_battery {
  CAPACITY=$(cat /sys/class/power_supply/BAT*/capacity)
  STATUS=$(cat /sys/class/power_supply/BAT*/status)

  if [ $STATUS = "Charging" ]; then
    ICON=""
  else
    if [ $CAPACITY == 100 ]; then
      ICON=""
    else if [ $CAPACITY -lt 10 ]; then
      ICON=""
    else
      ICON=$(printf "\u$(printf "%x" $((0xf578 + $CAPACITY / 10)))")
    fi fi
  fi

  echo "^c$blue^$ICON $CAPACITY%^d^"
}



internet() {
    local INTERVAL=1
    local INTERFACE="wlo1"

    print_bytes() {
        local SPEED=$1

        if [ "$SPEED" -lt 1000 ]; then
            echo "0 kB"
        elif [ "$SPEED" -lt 1000000 ]; then
            echo "$(( SPEED / 1000 )) kB"
        else
            echo "$( awk "BEGIN {printf \"%.1f\", $SPEED / 1000000}" ) MB"
        fi
    }

    read -r PREV_DOWN < /sys/class/net/$INTERFACE/statistics/rx_bytes
    read -r PREV_UP < /sys/class/net/$INTERFACE/statistics/tx_bytes

    sleep "$INTERVAL"

    read -r CUR_DOWN < /sys/class/net/$INTERFACE/statistics/rx_bytes
    read -r CUR_UP < /sys/class/net/$INTERFACE/statistics/tx_bytes

    local DOWN=$(( (CUR_DOWN - PREV_DOWN) / INTERVAL ))
    local UP=$(( (CUR_UP - PREV_UP) / INTERVAL ))

    echo "^c$green^$(print_bytes $DOWN)^d^ ^c$red^$(print_bytes $UP)^d^"
}




while true; do

  #[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))
  xsetroot -name "$(internet) $(get_battery) $(get_brightness) $(get_volume) $(cpu) $(mem) $(clock)" && sleep 5
done








# use printf is faster then echo

# running this command will refresh the bar.sh immediately
#kill "$(pstree -lp | grep -- -bar.sh\([0-9] | sed "s/.*sleep(\([0-9]\+\)).*/\1/" )"


# wlan() {
#   case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
#   up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
#   down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
#   esac
# }

# pkg_updates() {
#   updates=$(checkupdates | wc -l)   # arch
#
#   if [ -z "$updates" ]; then
#     printf "  ^c$green^    Fully Updated"
#   else
#     printf "  ^c$green^    $updates"" updates"
#   fi
# }

# battery() {
#   get_capacity="$(cat /sys/class/power_supply/BAT*/capacity)"
#   printf " 﫰 $get_capacity"
# }

# brightness() {
#   printf "  "
#   printf "%.0f\n" $(cat /sys/class/backlight/*/brightness)
# }



#mem() {
#  printf "^c$blue^^b$black^  "
#  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
#}

# wlan() {
# 	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
# 	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
# 	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
# 	esac
# }


while true; do

  #[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  #interval=$((interval + 1))

  xsetroot -name "$(battery) $(brightness) $(cpu) $(mem) $(clock)" && sleep 5 
done
