#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

#     _    _     ___    _    ____  _____ ____
#    / \  | |   |_ _|  / \  / ___|| ____/ ___|
#   / _ \ | |    | |  / _ \ \___ \|  _| \___ \
#  / ___ \| |___ | | / ___ \ ___) | |___ ___) |
# /_/   \_\_____|___/_/   \_\____/|_____|____/

# +----------------+
# | global aliases |
# +----------------+

alias -g G='| grep -'
alias -g L='| less'
alias -g C='| xclip'
alias -g H='| head'
alias -g N='&>/dev/null'
alias -g SL='| sort | less'
alias -g S='| sort -u'
alias -g T='| tail'
alias -g W='| wc -l'

# +--------+
# | xalias |
# +--------+

xalias() {
    local key val com
    if (( ${#argv} == 0 )) ; then
        printf 'xalias(): Missing argument.\n'
        return 1
    fi
    if (( ${#argv} > 1 )) ; then
        printf 'xalias(): Too many arguments %s\n' "${#argv}"
        return 1
    fi

    key="${1%%\=*}"
    val="${1#*\=}"

    words=(${(z)val})
    cmd=${words[1]}

    [[ -n ${commands[$cmd]} ]] && alias -- "${key}=${val}"
    return 0
}

xalias cal='cal -m'
xalias cp='cp --reflink=auto -iv'
xalias ctl='sudo systemctl'
xalias dd='dd status=progress'
xalias df='df -Thx tmpfs -x devtmpfs'
xalias diff='diff -Naur --strip-trailing-cr'
xalias dig='q'
xalias free='free -g'
xalias fuser='fuser -v'
xalias grep='grep --binary-files=without-match --directories=skip --color=auto'
xalias lg='lazygit'
xalias mkbz2='tar -cvjf'
xalias mkgz='tar -cvzf'
xalias mktar='tar -cvf'
xalias mv='mv -iv'
xalias pgrep='pgrep -a'
xalias reboot='sudo reboot'
xalias restart='sudo reboot'
xalias rm='trash -v'
xalias sha1='openssl sha1'
xalias sha256='openssl sha256'
xalias sha384='openssl sha384'
xalias sha512='openssl sha512'
xalias shutdown='sudo shutdown now'
xalias sl='ls'
xalias su='su - '
xalias top='htop'
xalias unbz2='tar -xvjf'
xalias ungz='tar -xvzf'
xalias untar='tar -xvf'

# +---------+
# | eza, ls |
# +---------+

if [[ -n ${commands[eza]} ]]; then
    export _ezaparams='--git --icons=auto --classify --group --group-directories-first --time-style=long-iso'
    alias ls='eza ${=_ezaparams}'
    alias ll='eza --all --header --long ${=_ezaparams}'
    alias llm='eza --all --header --long --sort=modified ${=_ezaparams}'
    alias lt='eza --tree ${=_ezaparams}'
    alias l='eza --git-ignore ${=_ezaparams}'
    alias tree='eza --all --git-ignore --tree ${=_ezaparams}'
else
    xalias ls='ls --color=auto --classify --human-readable'
fi

# +---------+
# | generic |
# +---------+

alias curl='noglob curl --compressed --proto-default https'
alias ln='nocorrect ln'
alias mkdir='nocorrect mkdir -p'
alias rmd='$(whence -p rm) -rfv'
alias wget='noglob wget --continue --show-progress --progress=bar:force:noscroll --hsts-file=$XDG_DATA_HOME/wget-hsts'

# +-----+
# | nix |
# +-----+

if [[ -n ${commands[nix]} ]]; then
    alias nix='noglob nix'
    alias nixos-rebuild='noglob sudo nixos-rebuild'
    alias nixos-remote='noglob nixos-remote'
    alias nom='noglob nom'
fi

# +------------------------+
# | procs - ps alternative |
# +------------------------+

if [[ -n ${commands[procs]} ]]; then
    xalias ps='procs'
else
    xalias ps='ps afux'
fi

# +--------+
# | rg, ag |
# +--------+

if [[ -n ${commands[rg]} ]]; then
    rg() {
        command rg -C1 --sort path --pretty --smart-case --fixed-strings "$@" | less -R
    }
    ag() {
        echo 'use rg instead'
        sleep 1
        rg "$@"
    }
elif [[ -n ${commands[ag]} ]]; then
    alias ag='ag --color --smart-case --literal --pager=$PAGER'
fi

# +-----+
# | zsh |
# +-----+

alias d='dirs -v'
# directory stack
for index ({1..9}) alias "$index"="cd +${index} > /dev/null"; unset index
