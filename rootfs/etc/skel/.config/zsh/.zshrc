# vim:syntax=zsh
# vim:filetype=zsh

#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

# +----------+
# | COMPINIT |
# +----------+

# Should call complist before compinit
zmodload zsh/complist

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_path="$XDG_CACHE_HOME/prezto/zcompdump"

#q expands globs in conditional expressions
if [[ $_comp_path(#qNmh-20) ]]; then
    compinit -C -d "$_comp_path"
else
    mkdir -p "$_comp_path:h"
    compinit -i -d "$_comp_path"
    touch "$_comp_path"
fi
unset _comp_path
_comp_options+=(globdots) # With hidden files

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

# +-------------+
# | ZSH PLUGINS |
# +-------------+

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=60
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
alias -g H='| head'
alias -g N='&>/dev/null'
alias -g SL='| sort | less'
alias -g S='| sort -u'
alias -g T='| tail'
alias -g W='| wc -l'

# +---------+
# | aliases |
# +---------+

# | xalias |
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
xalias mkbz2='tar -cvjf'
xalias mkgz='tar -cvzf'
xalias mktar='tar -cvf'
xalias mv='mv -iv'
xalias pgrep='pgrep -a'
xalias reboot='systemctl reboot'
xalias restart='systemctl reboot'
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

# | eza, ls |
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

#  ____ ___ _   _ ____ ___ _   _  ____ ____
# | __ )_ _| \ | |  _ \_ _| \ | |/ ___/ ___|
# |  _ \| ||  \| | | | | ||  \| | |  _\___ \
# | |_) | || |\  | |_| | || |\  | |_| |___) |
# |____/___|_| \_|____/___|_| \_|\____|____/

# +------------------------------------+
# | Using terminfo in Application Mode |
# +------------------------------------+

typeset -g -A key

key[Backspace]="${terminfo[kbs]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"
key[Delete]="${terminfo[kdch1]}"
key[Down]="${terminfo[kcud1]}"
key[End]="${terminfo[kend]}"
key[Home]="${terminfo[khome]}"
key[Insert]="${terminfo[kich1]}"
key[Left]="${terminfo[kcub1]}"
key[PageDown]="${terminfo[knp]}"
key[PageUp]="${terminfo[kpp]}"
key[Right]="${terminfo[kcuf1]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Up]="${terminfo[kcuu1]}"

[[ -n "${key[Backspace]}"     ]] && bindkey -- "${key[Backspace]}"     backward-delete-char
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"          down-line-or-history
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[Insert]}"        ]] && bindkey -- "${key[Insert]}"        overwrite-mode
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"          backward-char
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"      end-of-buffer-or-history
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"        beginning-of-buffer-or-history
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"         forward-char
[[ -n "${key[Shift-Tab]}"     ]] && bindkey -- "${key[Shift-Tab]}"     reverse-menu-complete
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"            up-line-or-history

# Finally, make sure the terminal is in application mode, when zle is active. Only then are the values from $terminfo valid.
# Downside: when a CLI / TUI doesn't use application mode, some keys won't work.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

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
    source /home/linuxbrew/.linuxbrew/etc/grc.zsh 2> /dev/null
    # | starship prompt |
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
    eval "$(starship init zsh)"
    # | thefuck alias |
    eval "$(thefuck --alias)"
    # | zoxide |
    eval "$(zoxide init zsh)"
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
