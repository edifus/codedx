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

# +---------+
# | BAZZITE |
# +---------+

_src_etc_profile_d()
{
    #  Make the *.sh things happier, and have possible ~/.zshenv options like
    # NOMATCH ignored.
    emulate -L ksh


    # from bashrc, with zsh fixes
    if [[ ! -o login ]]; then # We're not a login shell
        for i in /etc/profile.d/*.sh; do
            if [ -r "$i" ]; then
                . $i
            fi
        done
        unset i
    fi
}
_src_etc_profile_d && unset -f _src_etc_profile_d

# +-------------+
# | ZSH PLUGINS |
# +-------------+

if ! test -d $ZDOTDIR/plugins/fzf-tab; then
    git clone --depth 1 -- https://github.com/Aloxaf/fzf-tab $ZDOTDIR/plugins/fzf-tab
else
    GIT_DISCOVERY_ACROSS_FILESYSTEM=1 git -C $ZDOTDIR/plugins/fzf-tab pull > /dev/null
fi

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=60
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# +-------------+
# | ALIASES     |
# | BINDINGS    |
# | COLORS      |
# | COMPLETIONS |
# | SCRIPTS     |
# +-------------+

fignore=(.DS_Store $fignore)
fpath+=(/usr/share/zsh/site-functions)

eval "$(dircolors -b $ZDOTDIR/conf/dircolors)"
source $ZDOTDIR/conf/aliases.zsh
source $ZDOTDIR/conf/bd.zsh
source $ZDOTDIR/conf/bindings.zsh
source $ZDOTDIR/conf/completion.zsh
source $ZDOTDIR/conf/scripts_fzf.zsh
source $ZDOTDIR/conf/scripts.zsh

# +-----+
# | NIX |
# +-----+

# | nix function paths |
[[ -d $HOME/.nix-profile/share/zsh/site-functions ]] && \
    fpath+=($HOME/.nix-profile/share/zsh/site-functions)
[[ -d /run/current-system/sw/share/zsh/site-functions ]] && \
    fpath+=(/run/current-system/sw/share/zsh/site-functions)


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

# +--------+
# | PROMPT |
# +--------+

if [[ -o interactive ]]; then
    # | atuin |
    export ATUIN_NOBIND="true"
    eval "$(atuin init zsh)"
    bindkey '^r' atuin-search
    bindkey '^[[A' _atuin_up_search_widget
    bindkey '^[OA' _atuin_up_search_widget
    # | direnv |
    eval "$(direnv hook zsh)"
    # | fzf |
    source /usr/share/fzf/shell/key-bindings.zsh
    # | grc colorizer |
    source /usr/etc/grc.zsh 2> /dev/null
    # | linuxbrew |
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    if type brew &>/dev/null; then
        if [[ -w /home/linuxbrew/.linuxbrew ]]; then
            if [[ ! -L "$(brew --prefix)/share/zsh/site-functions/_brew" ]]; then
                brew completions link
            fi
        fi
    fi
    # | starship prompt |
    eval "$(starship init zsh)"
    # | zoxide |
    eval "$(zoxide init zsh)"
fi

# +--------------+
# | User scripts |
# +--------------+

if [ -d "$ZDOTDIR/user" ]; then
    for f in $ZDOTDIR/user/*.zsh; do
        source "$f"
    done && unset f
fi

# +----------+
# | TERMINAL |
# +----------+

# | turn off control character echoing |
stty -ctlecho

# | set tab width of 2 on TTY |
if [[ $TERM = linux ]]; then setterm -regtabs 2; fi

# | prevent broken terminals | reset to sane defaults after a command
ttyctl -f
