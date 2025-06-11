#!/usr/bin/env bash
set -eoux pipefail

echo "::group::Executing install-apps.sh"
trap 'echo "::endgroup::"' EXIT

# create directories
mkdir -pv /var/{opt,roothome}

## Extra apps (built-in repos)
# fedora
dnf5 install -y \
    android-tools \
    aria2 \
    bcc \
    bleachbit \
    blueprint-compiler \
    bpftop \
    bpftrace \
    ccache \
    flatpak-builder \
    fuse-btfs \
    fuse-devel \
    fuse3-devel \
    gettext \
    gnome-disk-utility \
    gparted \
    gtk4-devel \
    gwenview \
    isoimagewriter \
    kcalc \
    kgpg \
    ksystemlog \
    libadwaita-devel \
    nicstat \
    numactl \
    openrgb \
    plymouth-plugin-script \
    podman-machine \
    podman-tui \
    python3-ramalama \
    qemu-kvm \
    rclone \
    restic \
    sysprof \
    tiptop \
    virt-manager \
    virt-viewer \
    yt-dlp \
    zig-0.13.0-8.fc42 \
    zsh

# Install full virtualization group
dnf5 -y group install --with-optional virtualization

# fedora-multimedia
dnf5 -y install --enable-repo="*fedora-multimedia*" \
    HandBrake-cli \
    HandBrake-gui \
    mpv \
    vlc \
    vlc-plugin-ffmpeg \
    vlc-plugin-kde \
    vlc-plugin-pause-click \
    vlc-plugin-samba

# terra
dnf5 -y install --enable-repo="terra" \
    coolercontrol

# ublue-os
dnf5 install --enable-repo="copr:copr.fedorainfracloud.org:ublue-os:packages" -y \
    ublue-setup-services

# Adding repositories should be a LAST RESORT. Contributing to Terra or `ublue-os/packages` is much preferred
# over using random coprs. Please keep this in mind when adding external dependencies.
# If adding any dependency, make sure to always have it disabled by default and _only_ enable it on `dnf install`

# cloudflare warp
dnf5 config-manager addrepo --from-repofile="https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo"
dnf5 config-manager setopt cloudflare-warp-stable.enabled=0
dnf5 -y install --enable-repo="cloudflare-warp-stable" \
    cloudflare-warp

# vscode
dnf5 config-manager addrepo --set=baseurl="https://packages.microsoft.com/yumrepos/vscode" --id="vscode"
dnf5 config-manager setopt vscode.enabled=0
# FIXME: gpgcheck is broken for vscode due to it using `asc` for checking
# seems to be broken on newer rpm security policies.
dnf5 config-manager setopt vscode.gpgcheck=0
dnf5 install --nogpgcheck --enable-repo="vscode" -y \
    code

# docker-ce
docker_pkgs=( containerd.io docker-buildx-plugin docker-ce docker-ce-cli docker-compose-plugin )
dnf5 config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo"
dnf5 config-manager setopt docker-ce-stable.enabled=0
dnf5 install -y --enable-repo="docker-ce-stable" "${docker_pkgs[@]}" || {
    # Use test packages if docker pkgs is not available for f42
    if (($(lsb_release -sr) == 42)); then
        echo "::info::Missing docker packages in f42, falling back to test repos..."
        dnf5 install -y --enable-repo="docker-ce-test" "${docker_pkgs[@]}"
    fi
}
# Load iptable_nat module for docker-in-docker.
mkdir -pv /etc/modules-load.d && cat >>/etc/modules-load.d/ip_tables.conf <<EOF
iptable_nat
EOF

## Build ghostty terminal from source
git clone https://github.com/ghostty-org/ghostty /ghostty
cd /ghostty && git checkout v1.1.3
# build
zig build --verbose --prefix /usr -Doptimize=ReleaseFast -Dcpu=baseline
# cleanup build
cd / && rm -fr /ghostty /root/.cache/zig
dnf5 -y remove blueprint-compiler gettext gtk4-devel zig-0.13.0-8.fc42

## Workaround to allow ostree installation of Nix daemon
mkdir -pv /nix
