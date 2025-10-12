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

# Setup code editors default configuration
configure-editors:
    #!/usr/bin/env bash
    set -eou pipefail

    for editor in "Cursor" "Code"; do
      echo "Setting up $editor configuration..."
      config_dir="${HOME}/.config/${editor}/User"
      mkdir -p "$config_dir"
      cp -f "/etc/skel/.config/${editor}/User/settings.json" "$config_dir/settings.json"
      echo "$editor setup complete."
    done

# Setup Ghostty terminal configuration
configure-ghostty:
    #!/usr/bin/env bash
    set -eou pipefail

    echo "Setting up Ghostty 👻👻👻 configuration..."
    config_dir="${HOME}/.config/ghostty"
    mkdir -p "$config_dir"
    cp -f "/etc/skel/.config/ghostty/config" "$config_dir/config"
    echo "Ghostty 👻👻👻 setup complete."

configure-qemu-home-access:
    #!/usr/bin/env bash
    set -euo pipefail

    source /usr/lib/ujust/ujust.sh
    if [[ $(id -u) -eq 0 ]]; then
      echo "Please do not run this command as root"
      exit 1
    fi
    sudo setfacl -m u:qemu:rx $HOME && \
    echo "qemu can now read ISO files from $HOME"

# Setup zsh shell configuration
configure-zsh-shell:
    #!/usr/bin/env bash
    set -eou pipefail

    # Setup Starship prompt
    echo "Setting up Starship 🚀🚀🚀 prompt..."
    mkdir -p "$HOME/.config/starship"
    cp -f /etc/skel/.config/starship/starship.toml "$HOME/.config/starship/starship.toml"

    # Setup Zsh shell configuration
    echo "Setting up Zsh configuration..."
    config_dir="${HOME}/.config/zsh"
    rm -rfv "$config_dir"
    cp -afr /etc/skel/.config/zsh "$config_dir"
    cp -f /etc/skel/.zshenv "$HOME/.zshenv"
    rm -f "$HOME/.zshrc"
    rm -f "$HOME/.zprofile"
    echo "Zsh setup complete"

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

# Install custom AppImage apps
install-codedx-appimages:
    #!/usr/bin/env bash
    set -euo pipefail

    DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-${HOME}/Downloads}"
    [ ! -d "$DOWNLOAD_DIR" ] && DOWNLOAD_DIR="$HOME"

    # Install Gear Lever if not installed
    flatpak list | grep -q "it.mijorus.gearlever" || flatpak --system -y install it.mijorus.gearlever

    while IFS=, read -r name url; do
      [ -z "$name" -o -z "$url" ] && continue
      echo "Processing $name..."

      # Skip if installed
      if flatpak run it.mijorus.gearlever --list-installed | grep -qi "${name}.appimage"; then
        echo "$name already installed"
        continue
      fi

      # Handle GitHub wildcards
      if [[ "$url" =~ github.com/([^/]+/[^/]+)/releases/download/[^/]*/([^/]*) ]] && [[ "$url" == *"*"* ]]; then
        pattern="$(echo "${BASH_REMATCH[2]}" | sed 's/\./\\./g' | sed 's/\*/.*/g')"
        # Try each release until we find one with an AppImage
        url=""
        while read -r release_url; do
          if [[ "$release_url" =~ $pattern ]]; then
            url="$release_url"
            break
          fi
        done < <(curl --retry 3 -sL "https://api.github.com/repos/${BASH_REMATCH[1]}/releases" | jq -r ".[].assets[].browser_download_url")
        [ -z "$url" ] && {
          echo "No release found for $name"
          continue
        }
      fi

      # Handle JSON API responses (like cursor.com API)
      if [[ "$url" != http*github.com* ]]; then
        response=$(curl --retry 3 -sL "$url")
        if echo "$response" | jq -e '.downloadUrl' >/dev/null 2>&1; then
          url=$(echo "$response" | jq -r '.downloadUrl')
          echo "  Found download URL in JSON: $url"
        elif echo "$response" | jq -e '.download_url' >/dev/null 2>&1; then
          url=$(echo "$response" | jq -r '.download_url')
          echo "  Found download URL in JSON: $url"
        fi
      fi

      # Download and install
      appimage="$DOWNLOAD_DIR/${name}.appimage"
      if aria2c --dir="$(dirname "$appimage")" --out="$(basename "$appimage")" --max-tries=3 --connect-timeout=30 "$url" && chmod +x "$appimage" && flatpak run it.mijorus.gearlever --integrate "$appimage" -y; then
        echo "$name installed successfully"
      else
        echo "Failed to install $name"
      fi
      rm -f "$appimage"
    done < <(curl --retry 3 -sL https://raw.githubusercontent.com/edifus/codedx/main/appimages)
    echo "AppImages installation complete."

# Install custom Flatpaks
install-codedx-flatpaks:
    #!/usr/bin/env bash
    set -eou pipefail

    echo "Installing Flatpak 📦📦📦 packages..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/edifus/codedx/main/flatpaks) flatpak --system -y install
    echo "Flatpak 📦📦📦 installation complete"

# Install Orchis KDE Theme
install-orchis-theme:
    #!/usr/bin/env bash
    set -eou pipefail

    echo "Installing Orchis KDE theme..."
    git clone https://github.com/vinceliuice/Orchis-kde "$HOME/Downloads/Orchis-kde"
    bash "$HOME/Downloads/Orchis-kde/install.sh"
    rm -fr "$HOME/Downloads/Orchis-kde"
    echo "Orchis KDE theme installation complete"

# Install and configure Nix package manager
setup-nix:
    #!/usr/bin/env bash
    set -eou pipefail

    echo "Setting up Nix package manager..."
    sudo mkdir /etc/nix
    echo '
    # Sane defaults
    download-buffer-size = 536870912
    extra-experimental-features = nix-command flakes auto-allocate-uids cgroups fetch-closure recursive-nix configurable-impure-env ca-derivations impure-derivations
    trusted-public-keys = cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE= cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE6t3xMio= cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU= cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU= cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8= cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ= cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o= cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y=
    trusted-substituters = https://cache.garnix.io https://cache.nixos.org https://nix-community.cachix.org https://numtide.cachix.org https://cache.flakehub.com
    trusted-users = root @wheel
    ' | sudo tee /etc/nix/nix.custom.conf

    NIX_DAEMON_SCRIPT="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    NIX_INSTALLER="https://install.determinate.systems/nix"
    curl --proto '=https' --tlsv1.2 -sSf -L "$NIX_INSTALLER" | sh -s -- install --no-confirm
    [ -f "$NIX_DAEMON_SCRIPT" ] && . "$NIX_DAEMON_SCRIPT"
    echo "Nix setup complete"

# Install and configure Nix package manager (Determinate Nix)
setup-nix-determinate:
    #!/usr/bin/env bash
    set -eou pipefail

    echo "Setting up Nix package manager..."
    sudo mkdir /etc/nix
    echo '
    # Sane defaults
    download-buffer-size = 536870912
    extra-experimental-features = nix-command flakes auto-allocate-uids cgroups fetch-closure recursive-nix configurable-impure-env ca-derivations impure-derivations
    trusted-public-keys = cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=
    trusted-substituters = https://cache.garnix.io https://cache.nixos.org https://nix-community.cachix.org https://numtide.cachix.org
    trusted-users = root @wheel
    ' | sudo tee /etc/nix/nix.custom.conf

    NIX_DAEMON_SCRIPT="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    NIX_INSTALLER="https://install.determinate.systems/nix"
    curl --proto '=https' --tlsv1.2 -sSf -L "$NIX_INSTALLER" | sh -s -- install --determinate --no-confirm
    [ -f "$NIX_DAEMON_SCRIPT" ] && . "$NIX_DAEMON_SCRIPT"
    echo "Nix setup complete"
