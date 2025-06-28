#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

#  ____  ____   ___  _____ ___ _     _____
# |  _ \|  _ \ / _ \|  ___|_ _| |   | ____|
# | |_) | |_) | | | | |_   | || |   |  _|
# |  __/|  _ <| |_| |  _|  | || |___| |___
# |_|   |_| \_\\___/|_|   |___|_____|_____|

#
# Executes commands at login before zshrc.
#
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
