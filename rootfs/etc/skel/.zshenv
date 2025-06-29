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

# +--------------+
# | FZF, RIPGREP |
# +--------------+

FZF_COLORS="bg+:-1,\
fg:gray,\
fg+:white,\
border:black,\
spinner:0,\
hl:yellow,\
header:blue,\
info:green,\
pointer:red,\
marker:blue,\
prompt:gray,\
hl+:red"

if [[ -n "${commands[fzf-share]}" ]]; then
    FZF_CTRL_R_OPTS=--reverse
    if [[ -n "${commands[fd]}" ]]; then
        export FZF_DEFAULT_COMMAND='fd --type f'
    else
        export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
    fi
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 60% \
    --border sharp \
    --layout reverse \
    --color '$FZF_COLORS' \
    --prompt '∷ ' \
    --pointer ▶ \
    --marker ⇒"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"
# export FZF_TMUX_OPTS="-p"

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

# +-----+
# | NIX |
# +-----+

if [[ -d ${HOME}/.nix-defexpr/channels ]]; then
    export NIX_PATH="$NIX_PATH:$HOME/.nix-defexpr/channels"
fi

if [[ -S /nix/var/nix/daemon-socket/socket ]]; then
    export NIX_REMOTE=daemon
fi

export NIX_USER_PROFILE_DIR="${NIX_USER_PROFILE_DIR:-/nix/var/nix/profiles/per-user/${USER}}"
export NIX_PROFILES="${NIX_PROFILES:-$HOME/.nix-profile}"

if [[ -z "$TERMINFO_DIRS" ]] || [[ -d $HOME/.nix-profile/share/terminfo ]]; then
    export TERMINFO_DIRS=$HOME/.nix-profile/share/terminfo
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

# If the execution of a command takes longer than
# specified (seconds), time statistics are printed
export REPORTTIME=4

# +------+
# | PATH |
# +------+

path=(
    $HOME/.bin
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
