# shellcheck disable=SC1091
# shellcheck disable=SC2148
# vim:syntax=bash
# vim:filetype=bash

# .bash_profile

# Get the aliases and functions
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
  export LANGUAGE=en_US.UTF-8
fi

export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESSCHARSET=utf-8

# XDG folder spec
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/.Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

# Populate bash completions, .desktop files, etc
if [ -z "${XDG_DATA_DIRS-}" ]; then
    # According to XDG spec the default is /usr/local/share:/usr/share, don't set something that prevents that default
    export XDG_DATA_DIRS="/usr/local/share:/usr/share:$HOME/.local/share:$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share"
else
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.local/share:$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share"
fi
export XDG_DATA_DIRS
