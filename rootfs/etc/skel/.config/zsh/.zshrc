#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#
# +-----------+
# | PROFILING |
# +-----------+

zmodload zsh/zprof

# +----------+
# | COMPINIT |
# +----------+

# Should be called before compinit

zmodload zsh/complist

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_path="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompdump"

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

# +--------+
# | PROMPT |
# +--------+

# | atuin |
if [[ -n "${commands[atuin]}" ]]; then
    export ATUIN_NOBIND="true"
    eval "$(atuin init zsh)"
    bindkey '^r' atuin-search
    bindkey '^[[A' _atuin_up_search_widget
    bindkey '^[OA' _atuin_up_search_widget
fi

# | direnv |
if [[ -n "${commands[direnv]}" ]]; then eval "$(direnv hook zsh)"; fi

# | fzf |
if [[ -n "${commands[fzf-share]}" ]]; then
    fpath+=($USR/share/fzf)
    source $USR/share/fzf/completion.zsh
    source $USR/share/fzf/key-bindings.zsh
fi

# | grc colorizer |
if [[ -n ${commands[grc]} ]]; then
    source /etc/grc.zsh 2> /dev/null || \
    source $USR/etc/grc.zsh 2> /dev/null || \
    true
fi

# | linuxbrew |
if [[ -o interactive ]] && [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    if type brew &>/dev/null; then
        if [[ -w /home/linuxbrew/.linuxbrew ]]; then
            if [[ ! -L "$(brew --prefix)/share/zsh/site-functions/_brew" ]]; then
                brew completions link
            fi
        fi
    fi
fi

# | starship prompt |
if [[ -n ${commands[starship]} && $TERM != "dumb" ]]; then
    eval "$(starship init zsh)"
fi

# | thefuck alias |
if [[ -n ${commands[thefuck]} && $TERM != "dumb" ]]; then
    eval "$(thefuck --alias)"
fi

# | zoxide alias |
if [[ -n ${commands[zoxide]} && $TERM != "dumb" ]]; then
    eval "$(zoxide init zsh)"
fi

# +-----+
# | NIX |
# +-----+

# | home-manager session |
if test -r "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"; then
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

# | home profile |
if test -r $HOME/.nix-profile/etc/profile.d/nix.sh; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

# | system profile |
if test -r /etc/profile.d/nix.sh; then
    source /etc/profile.d/nix.sh
fi

# +------------+
# | ALIASES    |
# | BINDINGS   |
# | COMPLETION |
# | SCRIPTS    |
# +------------+

source $ZDOTDIR/conf/aliases.zsh
source $ZDOTDIR/conf/bindings.zsh
source $ZDOTDIR/conf/completion.zsh
source $ZDOTDIR/conf/scripts.zsh

# +-------------+
# | ZSH PLUGINS |
# +-------------+

if ! test -d $ZDOTDIR/plugins/zsh-autocomplete; then
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZDOTDIR/plugins/zsh-autocomplete
else
    git pull -C $ZDOTDIR/plugins/zsh-autocomplete
fi

if ! test -d $ZDOTDIR/plugins/zsh-autopair; then
    git clone --depth 1 -- https://github.com/hlissner/zsh-autopair $ZDOTDIR/plugins/zsh-autopair
else
    git pull -C $ZDOTDIR/plugins/zsh-autopair
fi

if ! test -d $ZDOTDIR/plugins/zsh-autosuggestions; then
    git clone --depth 1 -- https://github.com/zsh-users/zsh-autosuggestions $ZDOTDIR/plugins/zsh-autosuggestions
else
    git pull -C $ZDOTDIR/plugins/zsh-autosuggestions
fi

if ! test -d $ZDOTDIR/plugins/fast-syntax-highlighting; then
    git clone --depth 1 -- https://github.com/zdharma-continuum/fast-syntax-highlighting $ZDOTDIR/plugins/fast-syntax-highlighting
else
    git pull -C $ZDOTDIR/plugins/fast-syntax-highlighting
fi

source $ZDOTDIR/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZDOTDIR/plugins/zsh-autopair/autopair.zsh && autopair-init
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# +--------------+
# | User scripts |
# +--------------+

if [ -d "$ZDOTDIR/user" ]; then
    for f in $ZDOTDIR/user/*.zsh; do
        source "$f"
    done && unset f
fi

### bling.sh source start
test -f /usr/share/bazzite-cli/bling.sh && source /usr/share/bazzite-cli/bling.sh
### bling.sh source end

# +----------+
# | TERMINAL |
# +----------+

# | turn off control character echoing |
stty -ctlecho

# | set tab width of 2 on TTY |
if [[ $TERM = linux ]]; then setterm -regtabs 2; fi

# | prevent broken terminals | reset to sane defaults after a command
ttyctl -f
