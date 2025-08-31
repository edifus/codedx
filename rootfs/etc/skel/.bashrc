#!/usr/bin/env bash
# vim:syntax=bash
# vim:filetype=bash

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    # shellcheck disable=SC1091
    source /etc/bashrc
fi

# User specific environment
# shellcheck disable=SC2076
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d "$HOME/.bashrc.d" ]; then
    for rc in "$HOME"/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            # shellcheck disable=SC1090
            source "$rc"
        fi
    done
fi
unset rc


# Shell color (Nord theme)
eval "$(dircolors -b """$XDG_CONFIG_HOME"""/dircolors/nord.theme)"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init bash)"

# Atuin
export ATUIN_NOBIND="true"
### bling.sh source start
# shellcheck disable=SC1091
test -f /usr/share/bazzite-cli/bling.sh && source /usr/share/bazzite-cli/bling.sh
### bling.sh source end
bind -x '"\C-r": __atuin_history'

# fnm
eval "$(fnm env --use-on-cd --shell bash)"

# Rust
export PATH="/home/linuxbrew/.linuxbrew/opt/rustup/bin:$PATH"