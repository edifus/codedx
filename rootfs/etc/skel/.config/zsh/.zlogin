#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# Execute code in the background to not affect the current session
(
    # <https://github.com/zimfw/zimfw/blob/master/login_init.zsh>
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile
    local ZSHCONFIG="$ZDOTDIR"

    # Compile zcompdump, if modified, to increase startup speed.
    zcompdump="$ZSHCONFIG/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zrecompile -pq "$zcompdump"
    fi
    # zcompile .zshrc
    zrecompile -pq $HOME/.zshenv
    zrecompile -pq $ZSHCONFIG/.zprofile
    zrecompile -pq $ZSHCONFIG/.zshrc

    # recompile all zsh or sh
    _ZSHFILES=( $ZSHCONFIG/conf/*.*sh )
    for f in $_ZSHFILES; do
        zrecompile -pq $f
    done
) &!
