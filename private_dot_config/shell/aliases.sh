## add ".sh" file extension for text editor that this is a shell file for Syntax highlighting
## run command without alias example: $/usr/bin/ls ---or---  $command ls ---or--- check alias by $which ls ---or--- $type ls
### EXPORT ###

###--------------------------------- for bash only -------------------------------------###
## export HISTCONTROL=ignoreboth:erasedups  ### Do not save duplicate entries in history (prevents duplicates within a single terminal session only)   ## somthing like this is already configured in .zshrc
## bind "set completion-ignore-case on"     ### ignore upper and lowercase when TAB completion  ### somthing like this already configured in .zshrc

#### its only for bash but if you want to use it for zsh you need to change "shopt to setopt" ####
# shopt -s autocd # change to named directory
# shopt -s cdspell # autocorrects cd misspellings
# shopt -s cmdhist # save multi-line commands in history as single line
# shopt -s dotglob
# shopt -s histappend # do not overwrite history
# shopt -s expand_aliases # expand aliases

#PS1='[\u@\h \W]\$ '     ### this is a bash prompt (maybe not required)

###-------------------------------------------------------------------------------------###

#Ibus settings if you need them (it's for chinese and japanese type of languages to work on english keyboard for typing)
#type ibus-setup in terminal to change settings and start the daemon
#delete the hashtags of the next lines and restart
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=dbus
#export QT_IM_MODULE=ibus

setopt GLOB_DOTS ## show dot files (for bash and zsh both) # for example now you can use the command like $rm -rf * to delete both regular and hidden files in a single operation

### custom man page location which is seprated form system wide man page
# export MANPATH="/usr/local/man:$MANPATH"  ### it will check the man page in this custom location first and if the man page is not present there it will look for system wide man page

# You may need to manually set your language environment
# export LANG=en_US.UTF-8 ## already set the environment varibale at installation time ## use "echo $LANG" to see it  

# Compilation flags (usually not needed in linux, only for macOS)
# export ARCHFLAGS="-arch x86_64"   ## will create only 64 bit binary
# export ARCHFLAGS="-arch i386"     ## will create only 32 bit binary
### if comment all above flag then create universal binaries (not specific to 32bit or 64bit) 



###################################################################################
#############################  Tushant Aliases ####################################
###################################################################################

################################################################################### 
### rules for the aliases to prevent slow shell startup or any unexpected error  ##
###################################################################################
# 1. in aliases always use commands as literal string in the 'single quote' or use backslash for escape sequence in "double quote"
# 2. command substitution / expansion should not happen at the time of sourcing the .bashrc / .zshrc (it should happen while using the aliases)
# 3. to prevent the command substitution / expansion when sourcing the .bashrc / .zshrc use 'single quote' or use escape sequence in "double quote"

# alias alias1="$(sleep 10)"   # incorrect way (this will be evaluated every time automatically when the .bashrc / .zshrc will be sourced or when open the terminal)
# alias alias2="\$(sleep 10)"  # correct way   (we use escape sequence to use a command as literal string) this will evaluate when using the alias  
# alias alias3='$(sleep 10)'   # correct way   (this is already an literal string because it's single quoted) this will also evaluate when using the alias

# debug : check what is the actual alias used by the terminal... steps : open terminal > write below command
# alias <name of the alias>... example: alias alias1 --- or --- alias ls

# source of knowledge : on the alias "day" and "night" xrandr was giving the error "can't open display" on tty2 after login
# these rules are only applicable on aliases and not on functions because functions never get evaluated automatically






#Tushant_Aliases
  alias c='clear'
  alias x='exit'
  alias d='[ -d ~/work ] || mkdir ~/work && cd ~/work' # if directory exist then just cd and if it dosent exist then mkdir and then cd both
  alias dd='cd ~/Downloads'
  alias premove='sudo pacman -Rcns'
  alias pinstall='sudo pacman -S --noconfirm'
  alias cat='bat -p'    ## (cat -n ###this command can give the issue maybe any error on terminal)
  alias tree='tree -AC' #install tree before using this command
  alias tterminal='xfconf-query -c xfce4-terminal -p /background-darkness -s 0.8'  # source/syntex https://forum.xfce.org/viewtopic.php?id=16911
  alias bterminal='xfconf-query -c xfce4-terminal -p /background-darkness -s 1.0'  # source/syntex https://forum.xfce.org/viewtopic.php?id=16911
  alias cm='chezmoi'
  alias cdcm='chezmoi cd'
  alias yay='yay --color auto'
  alias vim='nvim'
  alias screenoff='xset dpms force off'
  alias diff='diff --color=auto'
  alias ip='ip --color=auto'
  alias cp='cp -i'   ## ask before overwrite
  alias ff='fastfetch'
  alias q='cd ..'
  alias sudo='sudo ' ## If the last character of the alias is a 'space' or 'tab' character then the next word of the command is also checked for an alias (now you can run your aliases with sudo command | this way you can create one alias by using multiple aliases like [ alias new_alias='alias1 alias2 alias3' ])

############################################################################################
######################## functions (alias with spaces lol)##################################
############################################################################################

catt() { local file_path="$(fzf --height=50% --layout=reverse --border --query "$1")" ; [[ -z "$file_path" ]] && return 1 || bat -p "$file_path" ; }
vimm() { local file_path="$(fzf --height=50% --layout=reverse --border --query "$1")" ; [[ -z "$file_path" ]] && return 1 || nvim   "$file_path" ; }
subll(){ local file_path="$(fzf --height=50% --layout=reverse --border --query "$1")" ; [[ -z "$file_path" ]] && return 1 || subl   "$file_path" ; }

cdd()  { local file_path="$(find .     -path '*/.cache/*' -prune -o        -path '*/.git/*' -prune -o         -type d -print | fzf --height=50% --layout=reverse --border --query "$1")" ;  [[ -z "$file_path" ]] && return 1 || cd "$file_path" ; }
# # -path '*/.cache/*' -prune -o       ==>  exclude some directory          ##  -print : it's the default option to print the path. other are : -delete , -exec

source <(fzf --zsh)    # for zsh only
# eval "$(fzf --bash)" # for bash only
# use ctrl+t  # to search for path file/directory
# use alt+c   # fuzzy cd into directory
# use ctrl+r  # to search command in history
# source https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration



# alias night="xrandr --output \$(xrandr | awk '/ connected/{print \$1}') --gamma 1.0:0.88:0.76 --brightness 1.0"
# alias day="xrandr --output \$(xrandr | awk '/ connected/{print \$1}') --gamma 1:1:1 --brightness 1.0"
warm() {
    local level="${1:-0}" # default when no argument is given
    local displayName="$(xrandr | awk '/ connected/{print $1}')"
  # local displayName="$(xrandr | awk '/connected/ && !/disconnected/ {print $1}' | tr '\n' ',' | sed 's/,$//')" ## for multi-display ## not tested
    case "$level" in
        0) xrandr --output $displayName --gamma 1:1:1          ;; # reset default
        1) xrandr --output $displayName --gamma 1.0:0.88:0.76  ;; # soft yellow
        2) xrandr --output $displayName --gamma 1.1:1.0:0.6    ;; # mild yellow
        3) xrandr --output $displayName --gamma 1.3:1.1:0.4    ;; # moderate yellow
        4) xrandr --output $displayName --gamma 1.6:1.3:0.6    ;; # strong yellow
        5) xrandr --output $displayName --gamma 2.0:1.5:0.3    ;; # hard yellow
        *) echo "Invalid level. Please choose a level between 0 and 6." ;;
    esac
}


# find file which is created and modified under 5 second and log it in the terminal
change() {  while true ; do find . -type f -cmin -0.083 ; sleep 1; done; }

# if $1 is a file then copy its path into clipboard otherwise use fzf to find the file and then copy its path
getpath() { 
  [ -f "$1" ] && { realpath $1 | sed "s|$HOME|\$HOME|g"  | tr -d '\n' | xclip -selection clipboard ; } ||
  { realpath $(find -type f | fzf) | sed "s|$HOME|\$HOME|g"  | tr -d '\n' | xclip -selection clipboard ; }
}

mkscript() {
[[ -z "$1" ]] && { script_name="$(read -re "script_name?Enter script name: "; echo "$script_name")"; } || { script_name="$1"; } #ask for script name if not specified
# [[ -z "$script_name" ]] && { echo "Script name cannot be empty. Exiting."; return 1; } # script name should not be empty
[ -e "$script_name" ] && { echo "File '$script_name' already exists."; return 1; };    # script name should not already exist
touch "$script_name" ; [ $? -ne 0 ] && { echo "Error occurred"; return 1; } ;  # stop the function if any error occured on touch #### script name should not be empty
echo '#!/usr/bin/env bash' > "$script_name" ; chmod +x "$script_name" ; $EDITOR "$script_name" ; # basic command
}


locate() {
  [[ -z "$1" ]] && echo "plocate: no pattern specified" && return 1 ;
  while true; do
    echo -n "Update locate database? (y/N): " ; read -r update_choice ; # ask for input oneliner. works on bash / zsh both
    update_choice=${update_choice:-n} # Set default to 'N' if input is empty
    case $update_choice in
      [yY] ) echo -e "$(tput setaf 2)Updating database....................$(tput sgr0) \n " && command sudo updatedb ; break ;;
      [nN] ) echo -e "$(tput setaf 3)Not updating the database............$(tput sgr0) \n "                          ; break ;;
        *  ) echo -e "$(tput setaf 1)Invalid input, please enter y or n...$(tput sgr0) \n "                                  ;;
    esac
  done
  command locate "$@"
}



tldr() {
  [[ -z "$1" ]] && echo "tldr: no pattern specified" && return 1 ;
  while true; do
    echo -n "Update tldr database? (y/N): " ; read -r update_choice ; # ask for input oneliner. works on bash / zsh both
    update_choice=${update_choice:-n} # Set default to 'N' if input is empty
    case $update_choice in
      [yY] ) echo -e "$(tput setaf 2)Updating database....................$(tput sgr0) \n " && command tldr -u ; break ;;
      [nN] ) echo -e "$(tput setaf 3)Not updating the database............$(tput sgr0) \n "                    ; break ;;
        *  ) echo -e "$(tput setaf 1)Invalid input, please enter y or n...$(tput sgr0) \n "                            ;;
    esac
  done
  command tldr "$@"
}

# NOTE: always use `command <name of the command>` inside function/script especially when your function name is same as your application name



# git log = git log --reverse
# git() {
#     if [ "$1" = "log" ]; then command git log --reverse ;
#     else command git "$@"; fi ;
# }

# # smart cd into a file ## install fzf first
# cdd(){ cd "$(find -type d | fzf --query "$1")" ; }


# # open a text file ## and default application (NOT IN USE JUST FOR REFERENCE)
# catf() {
#   local file_path=$( fzf --query "$1") ; # only find regular files with fzf e.g. text, log, mp3, py ; (non regular files e.g. directory, Symbolic-Link)
#   [[ -z "$file_path" ]] && return 1 || bat "${file_path}" 
# }

# # open a text file ## and default application (NOT IN USE JUST FOR REFERENCE)
# open() {
#   local file_path=$(find -type f | fzf --query "$1") ; # only find regular files with fzf e.g. text, log, mp3, py ; (non regular files e.g. directory, Symbolic-Link)
#   [[ -z "$file_path" ]] && return 1 || local file_type=$(file -b --mime-type "$file_path")
#   [[ "${file_type}" == text/* ]] && $EDITOR "${file_path}" || xdg-open "${file_path}" ;
# }


############################################################################################
######################source:-https://youtu.be/_xxTcKJMnWQ##################################
############################################################################################


# If not running interactively, don't do anything
[[ $- != *i* ]] && return


if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

# if [ -d "$HOME/.local/bin" ] ;
#   then PATH="$HOME/.local/bin:$PATH"
# fi

### ALIASES ###

#list
alias ls='ls --color=auto --group-directories-first'  # tv added
alias la='ls -a'
alias ll='ls -AlFh' # tv-added
alias l='ls'
alias l.="ls -A | egrep '^\.'"
alias listdir="ls -d */ > list"

#pacman
alias sps='sudo pacman -S'
alias spr='sudo pacman -R'
alias sprs='sudo pacman -Rs'
alias sprdd='sudo pacman -Rdd'
alias spqo='sudo pacman -Qo'
alias spsii='sudo pacman -Sii'

# show the list of packages that need this package - depends mpv as example
function_depends()  {
    search=$(echo "$1")
    sudo pacman -Sii $search | grep "Required" | sed -e "s/Required By     : //g" | sed -e "s/  /\n/g"
    }

alias depends='function_depends'

#fix obvious typo's
alias cd..='cd ..'
alias pdw='pwd'
alias udpate='sudo pacman -Syyu'
alias upate='sudo pacman -Syyu'
alias updte='sudo pacman -Syyu'
alias updqte='sudo pacman -Syyu'
alias upqll='paru -Syu --noconfirm'
alias upal='paru -Syu --noconfirm'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#readable output
alias df='df -h'

#keyboard
alias give-me-azerty-be="sudo localectl set-x11-keymap be"
alias give-me-qwerty-us="sudo localectl set-x11-keymap us"

#setlocale
alias setlocale="sudo localectl set-locale LANG=en_US.UTF-8"
alias setlocales="sudo localectl set-x11-keymap be && sudo localectl set-locale LANG=en_US.UTF-8"

#pacman unlock
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias rmpacmanlock="sudo rm /var/lib/pacman/db.lck"

#arcolinux logout unlock
alias rmlogoutlock="sudo rm /tmp/arcologout.lock"

#which graphical card is working
alias whichvga="/usr/local/bin/arcolinux-which-vga"

#free
alias free="free -mt"

#continue download
alias wget="wget -c"

#userlist
alias userlist="cut -d: -f1 /etc/passwd | sort"

#merge new settings
alias merge="xrdb -merge ~/.Xresources"

# Aliases for software managment
# pacman
alias pacman='sudo pacman' #  '--color auto' is already enabled in /etc/pacman.conf
alias update='sudo pacman -Syyu'
alias upd='sudo pacman -Syyu'

# paru as aur helper - updates everything
alias pksyua="paru -Syu --noconfirm"
alias upall="paru -Syu --noconfirm"
alias upa="paru -Syu --noconfirm"

#ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
#grub issue 08/2022
alias install-grub-efi="sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi" ## no need for any --bootloader-id  ##tv-added

#add new fonts
alias update-fc='sudo fc-cache -fv'

#copy/paste all content of /etc/skel over to home folder - backup of config created - beware
#skel alias has been replaced with a script at /usr/local/bin/skel

#backup contents of /etc/skel to hidden backup folder in home/user
alias bupskel='cp -Rf /etc/skel ~/.skel-backup-$(date +%Y.%m.%d-%H.%M.%S)'

#copy shell configs
alias cb='cp /etc/skel/.bashrc ~/.bashrc && echo "Copied" && exec bash' ##tv made both similar
alias cz='cp /etc/skel/.zshrc ~/.zshrc && echo "Copied" && exec zsh'    ##tv made both similar
alias cf='cp /etc/skel/.config/fish/config.fish ~/.config/fish/config.fish && echo "Copied" && exec fish'    ##tv made both similar'

#switch between bash and zsh
alias tobash="sudo chsh \$USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh \$USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh \$USER -s /bin/fish && echo 'Now log out.'"

#switch between lightdm and sddm
alias tolightdm="sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm --needed ; sudo systemctl enable lightdm.service -f ; echo 'Lightm is active - reboot now'"
alias tosddm="sudo pacman -S sddm --noconfirm --needed ; sudo systemctl enable sddm.service -f ; echo 'Sddm is active - reboot now'"
alias toly="sudo pacman -S ly --noconfirm --needed ; sudo systemctl enable ly.service -f ; echo 'Ly is active - reboot now'"
alias togdm="sudo pacman -S gdm --noconfirm --needed ; sudo systemctl enable gdm.service -f ; echo 'Gdm is active - reboot now'"
alias tolxdm="sudo pacman -S lxdm --noconfirm --needed ; sudo systemctl enable lxdm.service -f ; echo 'Lxdm is active - reboot now'"

# kill commands
# quickly kill conkies
alias kc='killall conky'
# quickly kill polybar
alias kp='killall polybar'
# quickly kill picom
alias kpi='killall picom'

#hardware info --short
alias hw="hwinfo --short"

#audio check pulseaudio or pipewire
alias audio="pactl info | grep 'Server Name'"

#skip integrity check
alias paruskip='paru -S --mflags --skipinteg'
alias yayskip='yay -S --mflags --skipinteg'
alias trizenskip='trizen -S --skipinteg'

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#check cpu
alias cpu="cpuid -i | grep uarch | head -n 1"

#get fastest mirrors in your neighborhood
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 30 --number 10 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 30 --number 10 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 30 --number 10 --sort age --save /etc/pacman.d/mirrorlist"
#our experimental - best option for the moment
alias mirrorx="sudo reflector --age 6 --latest 20  --fastest 20 --threads 5 --sort rate --protocol https --save /etc/pacman.d/mirrorlist"
alias mirrorxx="sudo reflector --age 6 --latest 20  --fastest 20 --threads 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist"
alias ram='rate-mirrors --allow-root --disable-comments arch | sudo tee /etc/pacman.d/mirrorlist'
alias rams='rate-mirrors --allow-root --disable-comments --protocol https arch  | sudo tee /etc/pacman.d/mirrorlist'

#mounting the folder Public for exchange between host and guest on virtualbox
alias vbm="sudo /usr/local/bin/arcolinux-vbox-share"

#enabling vmware services
alias start-vmware="sudo systemctl enable --now vmtoolsd.service"
alias vmware-start="sudo systemctl enable --now vmtoolsd.service"
alias sv="sudo systemctl enable --now vmtoolsd.service"


#youtube download
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

#iso and version used to install ArcoLinux
alias iso="cat /etc/dev-rel | awk -F '=' '/ISO/ {print \$2}'"
alias isoo="cat /etc/dev-rel"

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# This will generate a list of explicitly installed packages
alias list="sudo pacman -Qqe"
#This will generate a list of explicitly installed packages without dependencies
alias listt="sudo pacman -Qqet"
# list of AUR packages
alias listaur="sudo pacman -Qqem"
# add > list at the end to write to a file

# install packages from list
# pacman -S --needed - < my-list-of-packages.txt

#clear
alias clean="clear; seq 1 \$(tput cols) | sort -R | sparklines | lolcat"

#search content with ripgrep
alias rg="rg --sort path"

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#nano for important configuration files
#know what you do in these files
alias nlxdm="sudo \$EDITOR /etc/lxdm/lxdm.conf"
alias nlightdm="sudo \$EDITOR /etc/lightdm/lightdm.conf"
alias npacman="sudo \$EDITOR /etc/pacman.conf"
alias ngrub="sudo \$EDITOR /etc/default/grub"
alias nconfgrub="sudo \$EDITOR /boot/grub/grub.cfg"
alias nmkinitcpio="sudo \$EDITOR /etc/mkinitcpio.conf"
alias nmirrorlist="sudo \$EDITOR /etc/pacman.d/mirrorlist"
alias narcomirrorlist="sudo \$EDITOR /etc/pacman.d/arcolinux-mirrorlist"
alias nsddm="sudo \$EDITOR /etc/sddm.conf"
alias nsddmk="sudo \$EDITOR /etc/sddm.conf.d/kde_settings.conf"
alias nfstab="sudo \$EDITOR /etc/fstab"
alias nnsswitch="sudo \$EDITOR /etc/nsswitch.conf"
alias nsamba="sudo \$EDITOR /etc/samba/smb.conf"
alias ngnupgconf="sudo \$EDITOR /etc/pacman.d/gnupg/gpg.conf"
alias nhosts="sudo \$EDITOR /etc/hosts"
alias nhostname="sudo \$EDITOR /etc/hostname"
alias nresolv="sudo \$EDITOR /etc/resolv.conf"
# alias nbb="\$EDITOR ~/.bashrc"
# alias nzz="\$EDITOR ~/.zshrc"
# alias nff="\$EDITOR ~/.config/fish/config.fish"
alias nneofetch="\$EDITOR ~/.config/neofetch/config.conf"
alias nplymouth="sudo \$EDITOR /etc/plymouth/plymouthd.conf"
alias nvconsole="sudo \$EDITOR /etc/vconsole.conf"

#reading logs with bat
alias lcalamares="bat /var/log/Calamares.log"
alias lpacman="bat /var/log/pacman.log"
alias lxorg="bat /var/log/Xorg.0.log"
alias lxorgo="bat /var/log/Xorg.0.log.old"

#gpg
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias fix-gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-keyserver="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg.conf ~/.gnupg/ ; echo 'done'"

#fixes
alias fix-permissions="sudo chown -R \$USER:\$USER ~/.config ~/.local"
alias keyfix="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias key-fix="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias keys-fix="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fixkey="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fixkeys="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fix-key="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fix-keys="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
#fix-sddm-config is no longer an alias but an application - part of ATT
#alias fix-sddm-config="/usr/local/bin/arcolinux-fix-sddm-config"
alias fix-pacman-conf="/usr/local/bin/arcolinux-fix-pacman-conf"
alias fix-pacman-keyserver="/usr/local/bin/arcolinux-fix-pacman-gpg-conf"
alias fix-grub="/usr/local/bin/arcolinux-fix-grub"
alias fixgrub="/usr/local/bin/arcolinux-fix-grub"

#maintenance
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias downgrada="sudo downgrade --ala-url https://ant.seedhost.eu/arcolinux/"

#hblock (stop tracking with hblock)
#use unhblock to stop using hblock
alias unhblock="hblock -S none -D none"

#systeminfo
alias probe="sudo -E hw-probe -all -upload"
alias sysfailed="systemctl list-units --failed"

#shutdown or reboot
alias ssn="sudo shutdown now"
alias sr="reboot"

#update betterlockscreen images
alias bls="betterlockscreen -u /usr/share/backgrounds/arcolinux/"

#give the list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"
alias xdw="ls /usr/share/wayland-sessions"

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#wayland aliases
alias wsimplescreen="wf-recorder -a"
alias wsimplescreenrecorder="wf-recorder -a -c h264_vaapi -C aac -d /dev/dri/renderD128 --file=recording.mp4"

#btrfs aliases
alias btrfsfs="sudo btrfs filesystem df /"
alias btrfsli="sudo btrfs su li / -t"

#snapper aliases
alias snapcroot="sudo snapper -c root create-config /"
alias snapchome="sudo snapper -c home create-config /home"
alias snapli="sudo snapper list"
alias snapcr="sudo snapper -c root create"
alias snapch="sudo snapper -c home create"

#Leftwm aliases
alias lti="leftwm-theme install"
alias ltu="leftwm-theme uninstall"
alias lta="leftwm-theme apply"
alias ltupd="leftwm-theme update"
alias ltupg="leftwm-theme upgrade"

#arcolinux applications
#att is a symbolic link now
#alias att="archlinux-tweak-tool"
alias adt="arcolinux-desktop-trasher"
alias abl="arcolinux-betterlockscreen"
alias agm="arcolinux-get-mirrors"
alias amr="arcolinux-mirrorlist-rank-info"
alias aom="arcolinux-osbeck-as-mirror"
alias ars="arcolinux-reflector-simple"
alias atm="arcolinux-tellme"
alias avs="arcolinux-vbox-share"
alias awa="arcolinux-welcome-app"

#git
alias rmgitcache="rm -r ~/.cache/git"
# alias grh="git reset --hard HEAD ; git clean -df" # reset tracked files to last commit ; delete untracked file ## tv-added (available this code in 'g' script in PATH variable)

#pamac
alias pamac-unlock="sudo rm /var/tmp/pamac/dbs/db.lock"

#moving your personal files and folders from /personal to ~
alias personal='cp -Rf /personal/* ~'

#create a file called .my_alias and put all your personal aliases
#in there. They will not be overwritten by skel.

#[[ -f ~/.my_alias ]] && . ~/.my_alias

# reporting tools - install when not installed
#neofetch
#screenfetch
#alsi
#paleofetch
#fetch
#hfetch
#sfetch
#ufetch
#ufetch-arco
#pfetch
#sysinfo
#sysinfo-retro
#cpufetch
#colorscript random
