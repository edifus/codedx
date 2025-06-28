#!/usr/bin/env zsh
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

export SYSTEM=$(uname -s)

# +-----+
# | XDG |
# +-----+

# Keep everything in $HOME/.config, only .zshenv needs to be in $HOME
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"

export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/.Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

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

# +----------------+
# | OTHER SOFTWARE |
# +----------------+

export DIRSTACKSIZE=30
export SCREENSHOT="$XDG_PICTURES_DIR/screenshots"
export TMUXP_CONFIGDIR="$XDG_CONFIG_HOME/tmuxp"
export VIMCONFIG="$XDG_CONFIG_HOME/vim"

# Like default, but without / -- ^W must be useful in paths, like it is in vim, bash, tcsh
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Enable Pipewire for SDL
export SDL_AUDIODRIVER=pipewire
export ALSOFT_DRIVERS=pipewire

# +------------+
# | REPORTTIME |
# +------------+

# If the execution of a command takes longer than
# specified (seconds), time statistics are printed
export REPORTTIME=4

# +------+
# | PATH |
# +------+

path=(
    $HOME/.bin
    $HOME/.cargo/bin
    $HOME/.local/bin
    $HOME/bin
    $GOPATH/bin
    /usr/local/bin
    /usr/local/sbin
    $path
)

# get rid of duplicate in *paths
typeset -gU cdpath fpath path

# remove non-existing entries from path
path=($^path(N))

export PATH
