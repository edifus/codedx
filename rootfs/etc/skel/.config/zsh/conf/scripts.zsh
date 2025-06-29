#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

#  ____   ____ ____  ___ ____ _____ ____
# / ___| / ___|  _ \|_ _|  _ \_   _/ ___|
# \___ \| |   | |_) || || |_) || | \___ \
#  ___) | |___|  _ < | ||  __/ | |  ___) |
# |____/ \____|_| \_\___|_|    |_| |____/

# +-------------------------+
# | compress, extract files |
# +-------------------------+

extract() {
    for file in "$@"
    do
        if [ -f $file ]; then
            _ex $file
        else
            echo "'$file' is not a valid file"
        fi
    done
}

# Extract files in their own directories
mkextract() {
    for file in "$@"
    do
        if [ -f $file ]; then
            local filename=${file%\.*}
            mkdir -p $filename
            cp $file $filename
            cd $filename
            _ex $file
            rm -f $file
            cd -
        else
            echo "'$1' is not a valid file"
        fi
    done
}

# Internal function to extract any archive
_ex() {
    case $1 in
        *.tar.bz2)  tar xjf $1      ;;
        *.tar.gz)   tar xzf $1      ;;
        *.bz2)      bunzip2 $1      ;;
        *.gz)       gunzip $1       ;;
        *.tar)      tar xf $1       ;;
        *.tbz2)     tar xjf $1      ;;
        *.tgz)      tar xzf $1      ;;
        *.zip)      unzip $1        ;;
        *.7z)       7z x $1         ;; # require p7zip
        *.rar)      7z x $1         ;; # require p7zip
        *.iso)      7z x $1         ;; # require p7zip
        *.Z)        uncompress $1   ;;
        *)          echo "'$1' cannot be extracted" ;;
    esac
}

# Compress a file
# TODO to improve to compress in any possible format
# TODO to improve to compress multiple files
compress() {
    local DATE="$(date +%Y%m%d-%H%M%S)"
    tar cvzf "$DATE.tar.gz" "$@"
}

# +------------------------+
# | filesystem, navigation |
# +------------------------+

fd() {
    if [[ -n "${commands[fd]}" ]]; then
        command fd "$@"
    else
        command find . -iname "*${*}*" 2>/dev/null
    fi
}

mkcd() {
    local dir="$*";
    local mkdir -p "$dir" && cd "$dir";
}

mkcp() {
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        cp -r "$@"
}

mkmv() {
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        mv "$@"
}

own() {
    if [[ -n "${commands[sudo]}" ]]; then
        sudo chown -R "$USER:$(id -gn)" "$@"
    else
        chown -R "$USER:$(id -gn)" "$@"
    fi
}

upfind() {
    local previous=
    local current=$PWD

    if [[ $# -ne 1 ]];then
        echo "$0 FILE_NAME"
        return 1
    fi

    while [[ -d "$current" && "$current" != "$previous" ]]; do
        local target_path=$current/$1
        if [[ -f "$target_path" ]]; then
            echo "$target_path"
            return 0
        else
        previous=$current
        current=$current:h
        fi
    done
    return 1
}

# +-------+
# | other |
# +-------+

# cheat - curl
cheat() {
    curl cheat.sh/$1
}

# kill process
killp() {
    local pid=$(procs --color=always "$1" | fzf --ansi -m --header='[kill:process]' --header-lines 2 | awk '{print $1}')
    if [[ "$pid" != "" ]]; then
        echo $pid | xargs sudo kill -${2:-9}
        killp
    fi
}

# matrix terminal screensaver
matrix () {
    local lines=$(tput lines)
    cols=$(tput cols)

    awkscript='
{
    letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
    lines=$1
    random_col=$3
    c=$4
    letter=substr(letters,c,1)
    cols[random_col]=0;
    for (col in cols) {
        line=cols[col];
        cols[col]=cols[col]+1;
        printf "\033[%s;%sH\033[2;32m%s", line, col, letter;
        printf "\033[%s;%sH\033[1;37m%s\033[0;0H", cols[col], col, letter;
        if (cols[col] >= lines) {
            cols[col]=0;
        }
    }
}
'

    echo -e "\e[1;40m"
    clear

    while :; do
        echo $lines $cols $(( $RANDOM % $cols)) $(( $RANDOM % 72 ))
        sleep 0.05
    done | awk "$awkscript"
}

# Generate a password - default 20 characters
pass() {
    local size=${1:-20}
    cat /dev/random | tr -dc '[:graph:]' | head -c$size
}

# weather
wttr() {
    local request="wttr.in/${1-Denver}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}
