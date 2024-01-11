## add ".sh" file extension for text editor that this is a shell file for Syntax highlighting

#---------------------------# Version Controle System #---------------------------#
# # Load version control information
# autoload -Uz vcs_info
# precmd() { vcs_info }

# zstyle ':vcs_info:*' enable git # enable git version control only other are (hg svn cvs etc..)
# zstyle ':vcs_info:*' check-for-changes true # Can be slow on big repos.
# zstyle ':vcs_info:*' unstagedstr '%F{red} %f'
# zstyle ':vcs_info:*' stagedstr '%F{green} %f'

# zstyle ':vcs_info:git:*' formats '%F{243}%b%f %a%m%c%u'   # show git branch name and git status

#---------------------------# Color Code Variable #---------------------------#

#####   ANSI Foreground color #####
local color_reset="%{$reset_color%}"
local fg_red="%{$fg[red]%}"
local fg_green="%{$fg[green]%}"
local fg_blue="%{$fg[blue]%}"
# local fg_black="%{$fg[black]%}"
# local fg_yellow="%{$fg[yellow]%}"
# local fg_magenta="%{$fg[magenta]%}"
# local fg_cyan="%{$fg[cyan]%}"
# local fg_white="%{$fg[white]%}"

####### ANSI background color #########
# local bg_black="%{$bg[black]%}"
# local bg_red="%{$bg[red]%}"
# local bg_green="%{$bg[green]%}"
# local bg_yellow="%{$bg[yellow]%}"
# local bg_blue="%{$bg[blue]%}"
# local bg_magenta="%{$bg[magenta]%}"
# local bg_cyan="%{$bg[cyan]%}"
# local bg_white="%{$bg[white]%}"


######### xTerm Foreground color ###########
local COLOR_reset=$'%f'
local GREY_color=$'%F{243}'
local PINK_color=$'%F{197}'
local SKY_color=$'%F{39}'

######### xTerm Background color ###########
# local BG_GOLD=$'%K{11}'    
# local BG_PURPLE=$'%K{13}'    
# local BG_TEAL=$'%K{14}'    
# local BG_ROYAL_BLUE=$'%K{19}'    
# local BG_BURGUNDY=$'%K{52}'    
# local BG_IVORY=$'%K{228}'   
# local BG_LAVENDER=$'%K{183}'   
# local BG_EMERALD_GREEN=$'%K{46}'
# other color code ### https://www.tweaking4all.com/software/macosx-software/xterm-color-cheat-sheet/

#  

#---------------------------# Variables #---------------------------#
# local return_code="%(?..$fg_red%? ↵ $color_reset)"                 # required by #--- prompt 1 ---# 
# local user_host="%B%(!.$fg_red.$fg_green)%n@%m%b$color_reset "      # required by #--- prompt 1 ---# 
local user_symbol="%B%(!.$fg_red#.$fg_green❯)%b$color_reset"
local current_dir="%B$fg_blue%~ %b$color_reset"
# local line1="$GREY_color╭─$COLOR_reset"                             # required by #--- prompt 1 ---# 
# local line2="$GREY_color╰─$COLOR_reset"                             # required by #--- prompt 1 ---# 
setopt PROMPT_SUBST # to use "$vcs_info_msg_0_" variable in the prompt directly

## syntex -----------##
## ( ? . CODE_IF_SUCCESS(show green prompt) . CODE_IF_FAILURE(show red prompt)           ) 
## ( ! . IF_IT'S_ROOT_USER(show red prompt) . IF_IT'S_NON_ROOT_USER(show green prompt)   )

#---------------------------# prompt 1 #---------------------------#

# PROMPT='${line1}${user_host}${current_dir}${vcs_info_msg_0_}
# ${line2}${user_symbol} '
# # RPROMPT='${return_code}'       # show the error code in return

#---------------------------# prompt 2 #---------------------------#

PROMPT='${current_dir}${vcs_info_msg_0_}${user_symbol} '

#---------------------------# prompt 3 #---------------------------#

# PROMPT='$GREY_color%n $PINK_color%~ $SKY_color${vcs_info_msg_0_}$color_reset ${user_symbol} '

#---------------------------# prompt 4 #---------------------------#

## --- enable only one from billow for bottom prompt --- ##
# local end="%{$(tput cup $LINES 0)%}"          
# local end="%{$(tput cup $(($LINES - 1)) 0)%}" 
# local end="%{$(tput cup $(tput lines) 0)%}"   
# precmd(){tput cup $(($LINES - 1)) 0 ; }       ## you can NOT use `local` in front of function


# PROMPT='${end}${current_dir}${vcs_info_msg_0_}${user_symbol} '

## source : https://www.reddit.com/r/zsh/comments/10lo0vg/how_can_i_force_the_shell_prompt_at_bottom/
## source : https://github.com/romkatv/powerlevel10k/issues/563







#---------------------------# Cheat sheet #---------------------------#

####### For version coltrol system ########
# # %b = BranchInfo(master)   
# # %a = action (merge or rebase)
# # %m = git stash info (IDK)   
# # %u = Show unstaged changes  
# # %c = Show staged changes

############## Prompt #####################
# # %F = Setup forground color
# # %f = Reset forground color
# # %n = User Name
# # %m = Host Name
# # %B = Bold the text in the prompt
# # %b = Remove the Boldness of text


#--------------------------- prompt source ------------------------------------------------------------------------#
# https://github.com/ohmyzsh/ohmyzsh   | rg vcs_info
# https://www.themoderncoder.com/add-git-branch-information-to-your-zsh-prompt/
# https://arjanvandergaag.nl/blog/customize-zsh-prompt-with-vcs-info.html
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Version-Control-Information
# https://www.tweaking4all.com/software/macosx-software/customize-zsh-prompt/#TemporaryvsPermanentCustomZShellprompt
