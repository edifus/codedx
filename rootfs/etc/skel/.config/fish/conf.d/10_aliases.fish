# vim:syntax=fish
# vim:filetype=fish

# eza - ls replacement
alias ls='eza --long --header --group-directories-first --icons=auto'
alias lsa='ls --all'
alias lsm='lsa --sort=modified'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt --all'
alias tree='eza --tree --git-ignore --icons --all'
alias sl='ls'

alias curl='command curl --compressed --proto-default https'
alias ff='fzf --preview "bat --style=numbers --color=always {}"'
alias grep='grep --binary-files=without-match --directories=skip --color=auto'
alias egrep='egrep --color=auto'
alias egrep='fgrep --color=auto'
alias pgrep='pgrep -a'
alias su='command su - '
alias top='btop'
function wget
    # alias wget="command wget --continue --show-progress --progress=bar:force:noscroll --hsts-file=$XDG_DATA_HOME/.wget-hsts"
    command wget --continue --show-progress --progress=bar:force:noscroll --hsts-file=$XDG_DATA_HOME/.wget-hsts $argv
end

# Build
function make
    # alias make="grc make -j$(nproc)"
    grc make -j$(nproc) $argv
end
function ninja
    # alias ninja="command ninja -j$(nproc)"
    command ninja -j$(nproc) $argv
end

# Compress / Extract
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias mktar='tar -cvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
alias untar='tar -xvf'

# Files / Folders
alias df='grc df -Thx tmpfs -x devtmpfs'
alias rm='trash -v'
alias rmd='rm -rfv'
alias sha1='openssl sha1'
alias sha256='openssl sha256'
alias sha384='openssl sha384'
alias sha512='openssl sha512'

function cp
    # alias cp='command cp --reflink=auto -iv'
    command cp --reflink=auto -iv $argv
end
function dd
    # alias dd='command dd status=progress'
    command dd status=progress $argv
end
function fuser
    # alias fuser='command fuser -v'
    command fuser -v $argv
end
function mkdir
    # alias mkdir='command mkdir -p'
    command mkdir -p $argv
end
function mv
    # alias mv='command mv -iv'
    command mv -iv $argv
end

# Pacman / AUR
alias cleanch='sudo pacman -Scc'
alias cleanup="sudo pacman -Rsn $(pacman -Qtdq)"
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias rmpkg='sudo pacman -Rsn'
alias update='sudo pacman -Syu'

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
