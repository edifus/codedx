#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# Execute code in the background to not affect the current session
(
    # <https://github.com/zimfw/zimfw/blob/master/login_init.zsh>
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile
    local ZSHCONFIG="${ZDOTDIR:-$HOME}/.zsh"

    # Compile zcompdump, if modified, to increase startup speed.
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zrecompile -pq "$zcompdump"
    fi
    # zcompile .zshrc
    zrecompile -pq ${ZDOTDIR:-${HOME}}/.zshrc
    zrecompile -pq ${ZDOTDIR:-${HOME}}/.zprofile
    zrecompile -pq ${HOME}/.zshenv
    # recompile all zsh or sh
    for f in $ZSHCONFIG/**/*.*sh
    do
        zrecompile -pq $f
    done
) &!
