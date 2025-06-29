#!/usr/bin/env bash
set -eoux pipefail

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

# apply ip forwarding before installing docker to prevent messing with lxc networking
sysctl -p

# load iptable_nat module for docker-in-docker.
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
dnf5 install -y \
    android-tools \
    aria2 \
    aurora-backgrounds \
    bash-color-prompt \
    bleachbit \
    borgbackup \
    ckb-next \
    code \
    coolercontrol \
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    eza \
    flatpak-builder \
    fuse-btfs \
    fuse-devel \
    fuse3-devel \
    genisoimage \
    ghostty \
    gparted \
    fw-fanctrl \
    jetbrainsmono-nerd-fonts \
    liquidctl \
    mpv \
    openrazer-daemon \
    openrgb \
    podman-machine \
    podman-tui \
    podmansh \
    python3-ramalama \
    rclone \
    restic \
    starship \
    tealdeer \
    ublue-fastfetch \
    ublue-setup-services \
    vlc \
    vlc-plugin-ffmpeg \
    vlc-plugin-gnome \
    vlc-plugin-kde \
    vlc-plugin-pause-click \
    vlc-plugin-samba \
    zsh

# disable repositories
for copr in ublue-os/packages ublue-os/staging
do dnf5 -y copr disable $copr
done && unset -v copr

dnf5 config-manager setopt "*fedora-multimedia*".enabled=0
dnf5 config-manager setopt docker-ce-stable.enabled=0
dnf5 config-manager setopt hardware_razer.enabled=0
dnf5 config-manager setopt terra.enabled=0
dnf5 config-manager setopt vscode.enabled=0

# enable virtualization
echo "Making sure swtpm will work"
if [ ! -d "/var/lib/swtpm-localca" ]; then
    mkdir /var/lib/swtpm-localca
fi
chown tss /var/lib/swtpm-localca
restorecon -rv /var/lib/libvirt
restorecon -rv /var/log/libvirt
if test ! -f "/etc/libvirt/hooks/qemu"; then
    echo "Adding libvirt qemu hooks"
    wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' -O /etc/libvirt/hooks/qemu
    chmod +x /etc/libvirt/hooks/qemu
    grep -A1 -B1 "# Add" /etc/libvirt/hooks/qemu | sed 's/^# //g'
    if test ! -d "/etc/libvirt/hooks/qemu.d"; then
        mkdir /etc/libvirt/hooks/qemu.d
    fi
fi

## Workaround to allow ostree installation of Nix daemon
mkdir -pv /nix
