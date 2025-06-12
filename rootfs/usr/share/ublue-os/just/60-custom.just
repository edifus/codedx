# Setup app defaults, Ghostty, shells, etc
custom-app-defaults:
    #!/usr/bin/env bash
    set -euo pipefail

    # Setup Ghostty configuration
    echo "Setting up Ghostty configuration..."
    config_dir="${HOME}/.config/ghostty"
    mkdir -p "$config_dir"
    cp -f "/etc/skel/.config/ghostty/config" "$config_dir/config"
    echo "Ghostty setup complete"

    # Setup Zsh configuration
    echo "Setting up Zsh configuration..."
    cp -f "/etc/skel/.zshrc" "${HOME}/.zshrc"
    cp -f "/etc/skel/.zprofile" "${HOME}/.zprofile"
    echo "Zsh configuration complete"

    # Setup Bash configuration
    echo "Setting up Bash configuration..."
    cp -f "/etc/skel/.bashrc" "${HOME}/.bashrc"
    cp -f "/etc/skel/.bash_profile" "${HOME}/.bash_profile"
    cp -f "/etc/skel/.bash_logout" "${HOME}/.bash_logout"
    echo "Bash configuration complete"

    # Setup vscode configuration
    echo "Setting up vscode configuration..."
    config_dir="${HOME}/.config/Code/User"
    mkdir -p "$config_dir"
    cp -f "/etc/skel/.config/Code/User/settings.json" "$config_dir/settings.json"
    echo "vscode setup complete"

# Restart Bluetooth to fix issues
custom-bt-fix:
    #!/usr/bin/env bash
    set -eou pipefail
    trap '[[ $BASH_COMMAND != echo* ]] && echo "+ $BASH_COMMAND"' DEBUG

    echo "Fixing Bluetooth..."
    sudo rfkill unblock all
    sudo rmmod btusb
    sudo modprobe btusb
    echo "Bluetooth fix complete"

# Give user docker.socket access
custom-docker-access:
    #!/usr/bin/env bash
    set -eou pipefail

    sudo systemctl enable --now docker.service
    sudo usermod -aG docker $USER
    echo "Logout to complete group membership change"

# Install custom Homebrews
custom-install-brews:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Installing Homebrews..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/edifus/codedx/main/homebrews) brew install
    echo "Homebrews installation complete."

# Install custom Flatpaks
custom-install-flatpaks:
    #!/usr/bin/env bash
    set -eou pipefail

    echo "Installing Flatpaks..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/edifus/codedx/main/flatpaks) flatpak --system -y install
    echo "Flatpaks installation complete"

# Install Nix package manager
custom-install-nix:
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
