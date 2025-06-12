# vim: set ft=make :
########################
### 60-custom.just
########################
## Standardized verbs
# configure- = configure something that is pre-installed on the image
# install-   = install something, no uninstall or configuration provided
# setup-     = install something and also provide configuration and/or uninstallation options
# toggle-    = turn something on/off, logic can be automatic or manual selection
# fix-       = apply fix/patch/workaround for something
# foo        = no verb is used for shortcuts or something deemed important enough to use a super memorable name

# Create boot to Windows desktop shortcut
configure-boot-to-windows:
    #!/usr/bin/env bash
    set -euo pipefail

    mkdir -p $HOME/.local/share/applications
    cp -r /usr/share/applications/boot-to-windows.desktop $HOME/.local/share/applications
    sed -i 's/Hidden=true/Hidden=false/' $HOME/.local/share/applications/boot-to-windows.desktop

# Setup app defaults, Ghostty, shells, etc
configure-custom-app-defaults:
    #!/usr/bin/env bash
    set -euo pipefail

    # Setup Ghostty configuration
    echo "Setting up Ghostty configuration..."
    # Setup Ghostty
    if test ! -e "$HOME"/.config/ghostty; then
        mkdir -p "$HOME"/.config/ghostty
        cp -f /etc/skel/.config/ghostty/config "$HOME"/.config/ghostty/config
    fi
    echo "Ghostty setup complete"

    # Setup vscode configuration
    echo "Setting up vscode configuration..."
    # Setup VSCode
    if test ! -e "$HOME"/.config/Code/User/settings.json; then
        mkdir -p "$HOME"/.config/Code/User
        cp -f /etc/skel/.config/Code/User/settings.json "$HOME"/.config/Code/User/settings.json
    fi
    echo "vscode setup complete"

# Restart Bluetooth to fix issues
fix-bt:
    #!/usr/bin/env bash
    set -eou pipefail
    trap '[[ $BASH_COMMAND != echo* ]] && echo "+ $BASH_COMMAND"' DEBUG

    echo "Fixing Bluetooth..."
    sudo rfkill unblock all
    sudo rmmod btusb
    sudo modprobe btusb
    echo "Bluetooth fix complete"

# Install all CodeDX curated apps
install-custom-all: custom-install-brews custom-install-flatpaks custom-install-nix

# Install custom Homebrews
install-custom-brews:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Installing Homebrews..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/edifus/codedx/main/homebrews) brew install
    echo "Homebrews installation complete."

# Install custom Flatpaks
install-custom-flatpaks:
    #!/usr/bin/env bash
    set -eou pipefail
    IMAGE_INFO="/usr/share/ublue-os/image-info.json"
    BASE_IMAGE_NAME=$(jq -r '."base-image-name"' < $IMAGE_INFO)

    echo "Installing Flatpaks..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/edifus/codedx/main/flatpaks) flatpak --system -y install
    [[ ${BASE_IMAGE_NAME} == 'silverblue' ]] && flatpak --system -y install runtime/com.jeffser.Alpaca.Plugins.AMD/x86_64/stable
    echo "Flatpaks installation complete"

# Install and configure Incus
setup-incus:
    #!/usr/bin/env bash

    echo 'Installing and configuring Incus.'
    /usr/libexec/codedx-incus

# Install and configure Nix package manager
setup-nix:
    #!/usr/bin/env bash
    set -eou pipefail

    echo "Setting up Nix package manager..."
    NIX_DAEMON_SCRIPT="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    NIX_INSTALLER="https://install.determinate.systems/nix"
    curl --proto '=https' --tlsv1.2 -sSf -L "$NIX_INSTALLER" | sh -s -- install --no-confirm
    [ -f "$NIX_DAEMON_SCRIPT" ] && . "$NIX_DAEMON_SCRIPT"

    echo '
    # Sane defaults
    download-buffer-size = 536870912
    experimental-features = nix-command flakes auto-allocate-uids cgroups fetch-closure recursive-nix configurable-impure-env ca-derivations impure-derivations
    trusted-public-keys = cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=
    trusted-substituters = https://cache.garnix.io https://cache.nixos.org https://nix-community.cachix.org https://numtide.cachix.org
    trusted-users = root @wheel
    ' | sudo tee /etc/nix/nix.custom.conf

    echo "Nix setup complete"
