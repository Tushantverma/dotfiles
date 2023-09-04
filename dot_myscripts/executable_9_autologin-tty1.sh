#!/bin/bash

# run the whole script as root 
[ "$EUID" -ne 0 ] && echo "This script requires root privileges." && exec sudo sh "$0" "$@"; 



directoryy="/etc/systemd/system/getty@tty1.service.d"



# Function to configure auto-login
configure_autologin() {

  read -p "Enter Username (Enter nothing for Current User): " username

  # if empty input then assing current username if non empty then assing entered username
  [ -z "$username" ] && { current_user=$(whoami) ; echo "Current user: $current_user" ; } || echo "You entered: $username"


  # if directory dose not exist then create
  [ ! -e "$directoryy" ] && mkdir -p $directoryy


  echo "
  [Service] 
  ExecStart= 
  ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $username %I $TERM" > $directoryy/autologin.conf


  # systemctl enable getty@tty1.service (it always in running)

  echo "Auto-login for user '$username' has been configured."

}





# Function to remove auto-login
remove_autologin() {

  rm -rf $directoryy

  # systemctl disable getty@tty1.service (it always in running)
  echo "Auto-login configuration has been removed."

}







# Main script
while true; do
  read -p "add remove exit: " action

  case "$action" in
    "add") configure_autologin ;;
    "remove") remove_autologin ;;
    "exit")    exit 0 ;;
     * ) echo "Invalid Input"  ;;
  esac

done





tput setaf 5 # magenta
echo "#--------------SCRIPT_ENDED--------------#"
tput sgr0    # reset




# source
# https://wiki.archlinux.org/title/getty#Virtual_console
