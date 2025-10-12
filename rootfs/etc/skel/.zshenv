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

export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"

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
