# vim:syntax=zsh
# vim:filetype=zsh

#  _____ _   ___     _____ ____   ___  _   _ __  __ _____ _   _ _____
# | ____| \ | \ \   / /_ _|  _ \ / _ \| \ | |  \/  | ____| \ | |_   _|
# |  _| |  \| |\ \ / / | || |_) | | | |  \| | |\/| |  _| |  \| | | |
# | |___| |\  | \ V /  | ||  _ <| |_| | |\  | |  | | |___| |\  | | |
# |_____|_| \_|  \_/  |___|_| \_\\___/|_| \_|_|  |_|_____|_| \_| |_|

# +------------+
# | INITIALIZE |
# +------------+

# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

# +-----+
# | XDG |
# +-----+

# Keep everything in $HOME/.config, only .zshenv needs to be in $HOME
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/.Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

# Populate bash completions, .desktop files, etc
typeset -UT XDG_DATA_DIRS xdg_data_dirs
if [ -z "${XDG_DATA_DIRS-}" ]; then
    # According to XDG spec the default is /usr/local/share:/usr/share, don't set something that prevents that default
    export XDG_DATA_DIRS="/usr/local/share:/usr/share:$HOME/.local/share:$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share"
else
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.local/share:$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share"
fi
# Remove duplicate paths
typeset -gU xdg_data_dirs
# Remove non-existent paths
xdg_data_dirs=($^xdg_data_dirs(N-/))
export XDG_DATA_DIRS

export SYSTEM=$(uname -s)

# +-----+
# | ZSH |
# +-----+

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"  # Zsh config directory (.zshrc, etc)
export HISTFILE="$ZDOTDIR/.zhistory"   # History filepath
export HISTSIZE=10000                  # Maximum events for internal history
export SAVEHIST=10000                  # Maximum events in history file

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ("$SHLVL" -eq 1 && ! -o LOGIN) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    source ${ZDOTDIR:-$HOME}/.zprofile
fi

# +--------+
# | EDITOR |
# +--------+

if [[ -n ${commands[nvim]} ]]; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

export ALTERNATE_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# +------------+
# | GCC COLORS |
# +------------+

# 0 = black  1 = red   2 = green
# 3 = yellow 4 = blue  5 = magenta
# 6 = cyan   7 = white 8 = not used
# 9 = reset (default)

# gcc colors
GCC_COLORS=''
GCC_COLORS+='error=01;31'
GCC_COLORS+=':warning=01;35'
GCC_COLORS+=':note=01;36'
GCC_COLORS+=':caret=01;32'
GCC_COLORS+=':locus=01'
GCC_COLORS+=':quote=01'
export GCC_COLORS

# +------------------+
# | LESS, MAN, PAGER |
# +------------------+

if [[ -n ${commands[moar]} ]]; then
    export PAGER="moar"
else
    export PAGER="less"
fi

export LESS="-FXisRM"
export MANWIDTH=80
export MANPAGER="$PAGER"
export READNULLCMD="$PAGER"

#-------------------------------------
# cap |  info   |  effect            |
#-----|---------|--------------------|
# md  |  bold   |  bold start        |
# us  |  smul   |  underline start   |
# ue  |  rmul   |  underline end     |
# mb  |  blink  |  blink start       |
# so  |  smso   |  standout start    |
# se  |  rmso   |  standout end      |
# me  |  sgr0   |  reset all         |
#     |  invis  |  invisible start   |
#     |  rev    |  reverse           |
#     |  setaf  |  foreground color  |
#     |  setab  |  background color  |

export LESS_TERMCAP_mb=$'\E[01;31m'     # begin blinking
export LESS_TERMCAP_md=$'\E[01;32m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'         # end mode
export LESS_TERMCAP_se=$'\E[0m'         # end standout-mode
export LESS_TERMCAP_so=$'\E[01;30;44m'  # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'         # end underline
export LESS_TERMCAP_us=$'\E[04;33m'     # begin underline
export GROFF_NO_SGR=1

# +-------+
# | PATHS |
# +-------+

fpath=(
    $HOME/.nix-profile/share/zsh/site-functions
    /run/current-system/sw/share/zsh/site-functions
    /usr/share/zsh/site-functions
    "${fpath[@]}"
)

path=(
    $HOME/.cargo/bin
    $HOME/.local/bin
    $GOPATH/bin
    /usr/local/bin
    /usr/local/sbin
    "${path[@]}"
)

# get rid of duplicate in paths
typeset -gU cdpath fpath path

# remove non-existing entries from paths
cdpath=($^cdpath(N-/))
fpath=($^fpath(N-/))
path=($^path(N-/))

export CDPATH
export FPATH
export PATH
