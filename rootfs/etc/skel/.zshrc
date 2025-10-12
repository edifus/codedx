# vim:syntax=zsh
# vim:filetype=zsh

#                                %@@@@@@@@@@@%
#                          @@@@@@#-----------*@@@@@
#                     @@@@%%-----===========-=---=#%@@
#                   @@@======---------------------====%@@
#                 @@#====-----------------------------=-=#@@
#              @@@%==-------------------------------**---==#@@
#             @@#==------------------------------------**--=-@@
#            @%==---------------------------------------***---#@@
#          @@*==-----------------------------------------*-*-==-@@
#         @@#==------------------------------------------**-*--==#@
#        @@#==---------------------------------------------***--==#@
#        @#-=----------------------------------------------*-**--=%@
#       @#-==--#%*=----------=-%%*--------------------------*-**--=%@
#       @--=----@@%-----------%@@---------------------------**-*--==@
#      @*==------%%*#%%%%%%%#*%%----------------------------**-*--==@
#     @@===------%%=+@@@@@@@+=%%--------------------------**-****-==@
#  @@--%===------%%=+%-----%+=%%-----------------==#@%%%#@%#+-***-=-%@
# @%=-*#==-------%%=+%-----%+=%%----------------#%%--====-*=#*-**--==@@
# @%=-%-=--------*#@%------#@%*----------------#===------**-#*-*-*--==#@
#  @@=%-==-------------------------------------=--------**=%#**-***-=-#@
#   @@@-==--------------------------------------------**-=@#-**-**--==*%@
#     @-=-------=-------=----------------------------**--@*--*-**-**-=--@
#     @-==------%%#=-@@@@#=-%%----------------------**-#%----**-*-*--=--@@
#     @#==----=-@%#==-###*==*%@------------------------#%----*-***-**--==@
#      @===----@%###=#####*-##%@#------------------=*@#------*--*-**---==@
#      @===----@%#############%@#-----------------%%#=-------***-**-*--==#@
#      @===----@%#############%@#---------------------------**-**-*-**--=-@
#      @@-==---@%#############%@#---------------------------*--**-**--*--=-@@
#       @-==---@%#############%@#--------------------------***-**-***-**--==@@@
#       @@#-=--@%--###%##%##*-%@#--------------------------***-**-****----=== @@@
#        @%-==- @#-*%%%%%%%#-#@ *------------------------**--*--------====-*@@@
#         @@-=-------------------------------------------**-*--===----#@@@@@
#          @@-=-----------------------------------------*-***--==%@@@@%@
#           @@#==--------------------------------------**-**-*---=-@@
#             @@-==-----------------------------------**-**--***--==@@
#              @@%*-=--------------------------------**-*****---=-=#-@@@
#                @@@===---------------------------**-*-------===-@@@@
#                  @@%%--====------------------*------=====-=%%@@
#                    @@@@%--======-=--=----------=====----@@@@
#                         @@@@@@@*---------------@@@@@@@@
#                                @@@@@@@@@@@@@@@@@

#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

source /usr/share/codedx-zsh-config/codedx-config.zsh

# +-------------+
# | ZSH OPTIONS |
# +-------------+

# | GENERAL |
setopt INTERACTIVECOMMENTS     # Allow inline comments
setopt LONG_LIST_JOBS          # Print job notifications in the long format by default
setopt MULTIOS                 # Perform implicit tees or cats when multiple redirections are attempted
setopt NO_BEEP                 # No neep on error in ZLE
setopt TRANSIENT_RPROMPT       # Remove any right prompt from display when accepting a command line
unsetopt FLOW_CONTROL          # Disable start/stop characters in shell editor

# | COMPLETION |
setopt ALWAYS_TO_END           # Move cursor to the end of a completed word
setopt AUTO_LIST               # Automatically list choices on ambiguous completion
setopt AUTO_MENU               # Show completion menu on a successive tab press
setopt AUTO_PARAM_SLASH        # If completed parameter is a directory, add a trailing slash
setopt COMPLETE_IN_WORD        # Complete from both ends of a word
setopt GLOB_COMPLETE           # Show autocompletion menu with globs
setopt MENU_COMPLETE           # Automatically highlight first element of completion menu
setopt PATH_DIRS               # Perform path search even on command names with slashes

# | NAVIGATION |
setopt AUTO_CD                 # Go to folder path without using cd
setopt AUTO_PUSHD              # Push the old directory onto the stack on cd
setopt CDABLE_VARS             # Change directory to a path stored in a variable
setopt CORRECT                 # Spelling correction
setopt EXTENDED_GLOB           # Use extended globbing syntax
setopt PUSHD_IGNORE_DUPS       # Do not store duplicates in the stack
setopt PUSHD_SILENT            # Do not print the directory stack after pushd or popd

# | HISTORY |
setopt APPEND_HISTORY          # Zsh sessions will append their history, rather than replace it
setopt EXTENDED_HISTORY        # Write the history file in the ':start:elapsed;command' format
setopt HIST_EXPIRE_DUPS_FIRST  # Expire a duplicate event first when trimming history
setopt HIST_FIND_NO_DUPS       # Do not display a previously found event
setopt HIST_IGNORE_ALL_DUPS    # Delete an old recorded event if a new event is a duplicate
setopt HIST_IGNORE_DUPS        # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE       # Do not record an event starting with a space
setopt HIST_REDUCE_BLANKS      # Remove superflous blanks from each command line being added to the history list
setopt HIST_SAVE_NO_DUPS       # Do not write a duplicate event to the history file
setopt HIST_VERIFY             # Do not execute immediately upon history expansion
setopt INC_APPEND_HISTORY      # APPEND_HISTORY lines are added incrementally instead of at exit
setopt SHARE_HISTORY           # Share history between all sessions

# +---------+
# | aliases |
# +---------+

# eza - ls replacement
alias ls='eza --long --header --group-directories-first --icons=auto'
alias lsa='ls --all'
alias lsm='lsa --sort=modified'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt --all'
alias tree='eza --tree --git-ignore --icons --all'
alias sl='ls'

alias curl='curl --compressed --proto-default https'
alias ff='fzf --preview "bat --style=numbers --color=always {}"'
alias grep='grep --binary-files=without-match --directories=skip --color=auto'
alias egrep='egrep --color=auto'
alias egrep='fgrep --color=auto'
alias pgrep='pgrep -a'
alias su='su - '
alias top='btop'
alias wget="wget --continue --show-progress --progress=bar:force:noscroll --hsts-file=$XDG_DATA_HOME/.wget-hsts"

# Build
alias make="make -j$(nproc)"
alias ninja="ninja -j$(nproc)"

# Compress / Extract
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias mktar='tar -cvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
alias untar='tar -xvf'

# Files / Folders
alias df='df -Thx tmpfs -x devtmpfs'
alias rm='trash -v'
alias rmd='rm -rfv'
alias sha1='openssl sha1'
alias sha256='openssl sha256'
alias sha384='openssl sha384'
alias sha512='openssl sha512'

alias cp='cp --reflink=auto -iv'
alias dd='dd status=progress'
alias fuser='fuser -v'
alias mkdir='mkdir -p'
alias mv='mv -iv'

# Systemd
alias ctl='sudo systemctl'
alias jctl='journalctl -p 3 -xb'
alias reboot='ctl reboot'
alias restart='ctl reboot'
alias shutdown='ctl poweroff'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Tools
alias d='docker'
alias hw='hwinfo --short'
alias r='rails'
alias vim='nvim'

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# +--------+
# | COLORS |
# +--------+

eval "$(dircolors -b """$XDG_CONFIG_HOME"""/dircolors/nord.theme)"

# +--------+
# | PROMPT |
# +--------+

if [[ -o interactive ]]; then
    # | linuxbrew |
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    if type brew &>/dev/null; then
        if [[ -w /home/linuxbrew/.linuxbrew ]]; then
            if [[ ! -L "$(brew --prefix)/share/zsh/site-functions/_brew" ]]; then
                brew completions link
            fi
        fi
    fi
    # | atuin |
    export ATUIN_NOBIND="true"
    eval "$(atuin init zsh)"
    bindkey '^r' atuin-search
    bindkey '^[[A' _atuin_up_search_widget
    bindkey '^[OA' _atuin_up_search_widget
    # | grc colorizer |
    source /etc/grc.zsh 2> /dev/null
    # | starship prompt |
    # export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
    # eval "$(starship init zsh)"
fi

# +--------------+
# | PATH CLEANUP |
# +--------------+

# get rid of duplicate in paths
typeset -gU cdpath fpath path

# remove non-existing entries from paths
cdpath=($^cdpath(N-/))
fpath=($^fpath(N-/))
path=($^path(N-/))

export CDPATH
export FPATH
export PATH

# +----------+
# | TERMINAL |
# +----------+

# | disable core dumps |
ulimit -S -c 0

# | turn off control character echoing |
stty -ctlecho

# | set tab width of 2 on TTY |
if [[ $TERM = linux ]]; then setterm -regtabs 2; fi

# | prevent broken terminals | reset to sane defaults after a command
ttyctl -f
