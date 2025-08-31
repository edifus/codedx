# CodeDX

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/codedx)](https://artifacthub.io/packages/search?repo=codedx)
[![Build CodeDX](https://github.com/edifus/codedx/actions/workflows/build.yml/badge.svg)](https://github.com/edifus/codedx/actions/workflows/build.yml)
[![Build ISOs](https://github.com/edifus/codedx/actions/workflows/build_iso.yml/badge.svg)](https://github.com/edifus/codedx/actions/workflows/build_iso.yml)

A custom Fedora Atomic image designed for gaming, development and daily use.

## Base System

- Built on Fedora 42
- Uses [Bazzite](https://bazzite.gg/) as the base image
- KDE Plasma 6.4 with Valve's themes from SteamOS

## Features

- [Bazzite features](https://github.com/ublue-os/bazzite#about--features)
- ADB, Fastboot and [Waydroid](https://docs.bazzite.gg/Installing_and_Managing_Software/Waydroid_Setup_Guide/)
- Curated list of [Flatpaks](https://github.com/edifus/codedx/blob/main/flatpaks) and [Homebrews](https://github.com/edifus/codedx/blob/main/rootfs/usr/share/ublue-os/homebrew/codedx.Brewfile)
- Cursor editor (AppImage)
- Distrobox and Toolbx
- Kvantum and Klassy theme engine
- Native apps:
  - Brave Browser
  - ckb-next and openrazer
  - CoolerControl, liquidctl, and OpenRGB
  - Discord
  - Docker
  - Firefox
  - Ghostty
  - QEMU/KVM/Virtual Machine Manager
  - VScode
- Nix package manager support (Determinate Nix or upstream Nix)
- Starship prompt, Zsh, and Atuin history search (Ctrl+R)

## Custom commands

The following `ujust` commands are available:

```bash
# Create boot-to-windows application
ujust configure-boot-to-windows

# Configure code editors (Cursor, VScode)
ujust configure-editors

# Configure Ghostty terminal
ujust configure-ghostty

# Configure QEMU ISO home access
ujust configure-qemu-home-access

# Configure Zsh shell
ujust configure-zsh-shell

# Restart Bluetooth to fix issues
ujust fix-bt

# Install AppImages
ujust install-codedx-appimages

# Install Flatpaks
ujust install-codedx-flatpaks

# Install Homebrews
ujust install-codedx-homebrews

# Install Orchis KDE THeme
ujust install-orchis-theme

# Install and configure Nix package manager (Upstream Nix)
ujust setup-nix

# Install and configure Nix package manager (Determinate Nix)
ujust setup-nix-determinate
```

## CodeDX Image Chart

> [!NOTE]
> The rest of this document uses an `<image>` placeholder. The actual image name can be referenced in the chart below.

| Image                       | Desktop Environment | Hardware                                 |
| --------------------------- | ------------------- | ---------------------------------------- |
| `codedx`                   | KDE Plasma          | AMD/Intel GPUs                           |
| `codedx-nvidia`            | KDE Plasma          | Nvidia GPUs                              |
| `codedx-nvidia-open`            | KDE Plasma          | Nvidia GPUs (Newer Nvidia GPUs)          |
| `codedx-gnome`             | GNOME               | AMD/Intel GPUs                           |
| `codedx-gnome-nvidia`      | GNOME               | Nvidia GPUs                              |
| `codedx-gnome-nvidia-open`      | GNOME               | Nvidia GPUs (Newer Nvidia GPUs)          |

## Install

If you want to install the image on a new system, download ISO under Artifacts from latest [Build ISO](https://github.com/edifus/codedx/actions/workflows/build_iso.yml) workflow run.

From an existing Bazzite/Fedora Atomic/Universal Blue installation, switch to a CodeDX image:

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/edifus/<image>:latest
```

### Verify

> [!IMPORTANT]
> Every CodeDX image should start with `ostree-image-signed:docker://ghcr.io/edifus/<image>`.

Verify your image by entering this **commmand**:

```bash
rpm-ostree status
```

### Validate

> [!NOTE]
> These images are signed with sigstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can validate the signature by downloading the `cosign.pub` key from this repo and following these instructions:

```bash
cosign verify --key cosign.pub ghcr.io/edifus/<image>
```

## Acknowledgments

This project is based on [Amy OS](https://github.com/astrovm/amyos), [Bazzite DX](https://github.com/ublue-os/bazzite-dx), and the [Universal Blue image template](https://github.com/ublue-os/image-template). It builds upon the excellent work of the entire Universal Blue community.
