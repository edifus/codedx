#!/usr/bin/bash

source /usr/lib/ublue/setup-services/libsetup.sh

version-script vscode-extensions-dx user 1 || exit 1

set -x

code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-azuretools.vscode-containers
