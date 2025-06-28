#!/usr/bin/env bash
set -eoux pipefail

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

# Apply IP Forwarding before installing Docker to prevent messing with LXC networking
sysctl -p

# Load iptable_nat module for docker-in-docker.
# See:
#   - https://github.com/ublue-os/bluefin/issues/2365
#   - https://github.com/devcontainers/features/issues/1235
mkdir -p /etc/modules-load.d && cat >>/etc/modules-load.d/ip_tables.conf <<EOF
iptable_nat
EOF

# create directories
mkdir -pv /var/{opt,roothome}

# setup repositories
for copr in ublue-os/packages ublue-os/staging
do dnf5 -y copr enable $copr
done && unset -v copr

dnf5 -y config-manager setopt "*fedora-multimedia*".enabled=true
dnf5 -y config-manager setopt terra.enabled=true
dnf5 config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo"
dnf5 config-manager addrepo --from-repofile="https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo"
dnf5 config-manager addrepo --from-repofile="https://openrazer.github.io/hardware:razer.repo"

# install packages
dnf5 -y group install --with-optional virtualization

dnf5 install -y \
    android-tools \
    aria2 \
    atuin \
    aurora-backgrounds \
    bash-color-prompt \
    bat \
    bcc \
    bchunk \
    bleachbit \
    borgbackup \
    bpftop \
    bpftrace \
    ccache \
    ckb-next \
    cloudflare-warp \
    code \
    coolercontrol \
    containerd.io \
    direnv \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    eza \
    fd-find \
    flatpak-builder \
    fuse-btfs \
    fuse-devel \
    fuse3-devel \
    fzf \
    genisoimage \
    gh \
    ghostty \
    glab \
    gparted \
    grc \
    gwenview \
    hack-nerd-fonts \
    firacode-nerd-fonts \
    fw-fanctrl \
    google-noto-fonts-all \
    HandBrake-cli \
    HandBrake-gui \
    iosevka-nerd-fonts \
    iosevkaterm-nerd-fonts \
    isoimagewriter \
    jetbrainsmono-nerd-fonts \
    kgpg \
    ksystemlog \
    libvirt-nss \
    liquidctl \
    monoid-nerd-fonts \
    mpv \
    neovim \
    nerdfontssymbolsonly-nerd-fonts \
    nicstat \
    numactl \
    openrazer-daemon \
    openrgb \
    plymouth-plugin-script \
    podman-machine \
    podman-tui \
    podmansh \
    python3-ramalama \
    qemu \
    qemu-char-spice \
    qemu-device-display-virtio-gpu \
    qemu-device-display-virtio-vga \
    qemu-device-usb-redirect \
    qemu-img \
    qemu-system-x86-core \
    qemu-user-binfmt \
    qemu-user-static \
    rclone \
    restic \
    starship \
    sysprof \
    tealdeer \
    thefuck \
    trash-cli \
    ublue-fastfetch \
    ublue-os-libvirt-workarounds \
    ublue-setup-services \
    ubuntu-nerd-fonts \
    ubuntumono-nerd-fonts \
    ubuntusans-nerd-fonts \
    ugrep \
    virt-v2v \
    vlc \
    vlc-plugin-ffmpeg \
    vlc-plugin-gnome \
    vlc-plugin-kde \
    vlc-plugin-pause-click \
    vlc-plugin-samba \
    yq \
    yt-dlp \
    zedmono-nerd-fonts \
    zoxide \
    zsh

# disable repositories
for copr in ublue-os/packages ublue-os/staging
do dnf5 -y copr disable $copr
done && unset -v copr

dnf5 config-manager setopt "*fedora-multimedia*".enabled=0
dnf5 config-manager setopt cloudflare-warp-stable.enabled=0
dnf5 config-manager setopt docker-ce-stable.enabled=0
dnf5 config-manager setopt hardware_razer.enabled=0
dnf5 config-manager setopt terra.enabled=0
dnf5 config-manager setopt vscode.enabled=0

# ls-iommu helper tool for listing devices in iommu groups (PCI Passthrough)
curl --retry 3 -Lo /tmp/kind "https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-$(uname)-amd64"
chmod +x /tmp/kind
mv /tmp/kind /usr/bin/kind

DOWNLOAD_URL=$(curl https://api.github.com/repos/HikariKnight/ls-iommu/releases/latest | jq -r '.assets[] | select(.name| test(".*x86_64.tar.gz$")).browser_download_url')
curl --retry 3 -Lo /tmp/ls-iommu.tar.gz "$DOWNLOAD_URL"
mkdir /tmp/ls-iommu
tar --no-same-owner --no-same-permissions --no-overwrite-dir -xvzf /tmp/ls-iommu.tar.gz -C /tmp/ls-iommu
mv /tmp/ls-iommu/ls-iommu /usr/bin/
rm -rf /tmp/ls-iommu*

## Workaround to allow ostree installation of Nix daemon
mkdir -pv /nix
