#!/bin/bash


directoryy="/etc/systemd/system/getty@tty1.service.d"


# Function to configure auto-login
configure_autologin() {

  # if directory dose not exist then create
  [ ! -e "$directoryy/autologin.conf" ] && sudo mkdir -p $directoryy || { echo "$(tput setaf 1)auto login already configured$(tput sgr0)" ; exit 1 ; }

  read -ep "Enter Username (Enter for Default $(whoami)): " username

  # if empty input then assing current username if non empty then assing entered username
  [ -z "$username" ] && { current_user=$(whoami) ; echo "Current user: $current_user" ; } || { current_user=$(username) ; echo "You entered: $current_user" ; }


  echo "
  [Service] 
  ExecStart= 
  ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $current_user %I $TERM" | sudo tee $directoryy/autologin.conf >/dev/null

  # sudo systemctl enable getty@tty1.service (it always in running)

  echo "$(tput setaf 2)Auto-login for user '$current_user' has been configured.$(tput sgr0)"

}





# Function to remove auto-login
remove_autologin() {

  
  [ -e "$directoryy" ] && sudo rm -rf $directoryy || { echo "$(tput setaf 1)auto login already removed$(tput sgr0)" ; exit 1 ; }

  # sudo systemctl disable getty@tty1.service (it always in running)
  echo "$(tput setaf 2)Auto-login configuration has been removed.$(tput sgr0)"

}






# Main script

echo "Enter a command :( add / remove )"
  read -ep "command : " action

  case "$action" in
    "add") configure_autologin ;;
    "remove") remove_autologin ;;
     * ) echo "Invalid Input"  ;;
esac






tput setaf 5 # magenta
echo "#--------------SCRIPT_ENDED--------------#"
tput sgr0    # reset


# source
# https://wiki.archlinux.org/title/getty#Virtual_console
