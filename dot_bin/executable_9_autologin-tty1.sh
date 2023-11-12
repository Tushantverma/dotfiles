#!/usr/bin/env bash


directoryy="/etc/systemd/system/getty@tty1.service.d"


####################################################################################################################
####################################################################################################################
enable_autologin() {

  # if directory dose not exist then create
  [ ! -e "$directoryy/autologin.conf" ] && sudo mkdir -p $directoryy || { echo "$(tput setaf 1)auto login already configured$(tput sgr0)" ; exit 1 ; }

  read -rep "$(tput setaf 3)In which user you want to Auto-login (press 'Enter' for Default $(whoami)): $(tput sgr0)" username

  # if empty input then assing current username if non empty then assing entered username
  [ -z "$username" ] && { current_user=$(whoami) ; echo "Current user is: $current_user" ; } || { current_user=$(username) ; echo "You entered: $current_user" ; }

  echo "
  [Service]  
  ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $current_user %I $TERM" | sudo tee $directoryy/autologin.conf >/dev/null

  # sudo systemctl enable getty@tty1.service (it always in running)
  echo "$(tput setaf 2)Auto-login for user '$current_user' has been configured.$(tput sgr0)"
}
####################################################################################################################
####################################################################################################################






####################################################################################################################
####################################################################################################################
disable_autologin() {
  [ -e "$directoryy" ] && sudo rm -rf $directoryy || { echo "$(tput setaf 1)auto login have already removed$(tput sgr0)" ; exit 1 ; }

  # sudo systemctl disable getty@tty1.service (it always in running)
  echo "$(tput setaf 2)Auto-login configuration has been removed.$(tput sgr0)"
}
####################################################################################################################
####################################################################################################################







####################################################################################################################
####################################################################################################################

read -rep "$(tput setaf 3)Auto-login : [ (e)nable / (d)isable ]: $(tput sgr0)" choice

  case $choice in
    e | enable  ) enable_autologin   ;;
    d | disable ) disable_autologin  ;;
     *)  echo "$(tput setaf 1)Invalid choice. Please enter [ (e)nable / (d)isable ] $(tput sgr0)" ; exit 1 ;;
  esac

####################################################################################################################
####################################################################################################################


echo "$(tput setaf 2)#--------------SCRIPT_ENDED--------------#$(tput sgr0)"


# source https://wiki.archlinux.org/title/getty#Virtual_console
