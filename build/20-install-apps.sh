#!/usr/bin/env bash
set -eoux pipefail

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

# create directories
mkdir -pv /var/{opt,roothome}

# setup repositories
for copr in karmab/kcli ublue-os/packages ublue-os/staging
do dnf5 -y copr enable $copr
done && unset -v copr

dnf5 -y config-manager setopt "*fedora-multimedia*".enabled=true
dnf5 -y config-manager setopt terra.enabled=true
dnf5 config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo"
dnf5 config-manager addrepo --from-repofile="https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo"

# install packages
dnf5 -y group install --with-optional virtualization

dnf5 install -y \
    android-tools \
    aria2 \
    bcc \
    bchunk \
    bleachbit \
    borgbackup \
    bpftop \
    bpftrace \
    ccache \
    cloudflare-warp \
    code \
    containerd.io \
    coolercontrol \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    flatpak-builder \
    fuse-btfs \
    fuse-devel \
    fuse3-devel \
    genisoimage \
    ghostty \
    gparted \
    gwenview \
    hack-nerd-fonts \
    HandBrake-cli \
    HandBrake-gui \
    iosevka-nerd-fonts \
    iosevkaterm-nerd-fonts \
    isoimagewriter \
    jetbrainsmono-nerd-fonts \
    kcli \
    kgpg \
    ksystemlog \
    libvirt-nss \
    monoid-nerd-fonts \
    mpv \
    nicstat \
    numactl \
    openrgb \
    plymouth-plugin-script \
    podman-machine \
    podman-tui \
    podmansh \
    python3-ramalama \
    qemu-user-binfmt \
    qemu-user-static \
    rclone \
    restic \
    starship \
    sysprof \
    thefuck \
    ublue-fastfetch \
    ublue-os-libvirt-workarounds \
    ublue-setup-services \
    ubuntu-nerd-fonts \
    ubuntumono-nerd-fonts \
    ubuntusans-nerd-fonts \
    virt-v2v \
    vlc \
    vlc-plugin-ffmpeg \
    vlc-plugin-gnome \
    vlc-plugin-kde \
    vlc-plugin-pause-click \
    vlc-plugin-samba \
    yt-dlp \
    zedmono-nerd-fonts \
    zsh \
    zsh-autocomplete \
    zsh-autosuggestions \
    zsh-syntax-highlighting \

# disable repositories
for copr in karmab/kcli ublue-os/packages ublue-os/staging
do dnf5 -y copr disable $copr
done && unset -v copr

dnf5 config-manager setopt "*fedora-multimedia*".enabled=0
dnf5 config-manager setopt cloudflare-warp-stable.enabled=0
dnf5 config-manager setopt docker-ce-stable.enabled=0
dnf5 config-manager setopt terra.enabled=0
dnf5 config-manager setopt vscode.enabled=0

# Load iptable_nat module for docker-in-docker.
mkdir -pv /etc/modules-load.d && cat >>/etc/modules-load.d/ip_tables.conf <<EOF
iptable_nat
EOF

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
