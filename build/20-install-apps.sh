#!/usr/bin/env bash
set -eoux pipefail

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

# apply '/usr/lib/sysctl.d/docker.conf' before installing docker to prevent messing with lxc networking
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
dnf5 config-manager addrepo --from-repofile="https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo"
dnf5 config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo"
dnf5 config-manager addrepo --from-repofile="https://openrazer.github.io/hardware:razer.repo"

# install packages
dnf5 install -y \
    android-tools \
    aria2 \
    aurora-backgrounds \
    bcc \
    bchunk \
    borgbackup \
    bpftop \
    bpftrace \
    brave-browser \
    ccache \
    code \
    coolercontrol \
    containerd.io \
    discord \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    flatpak-builder \
    fuse-btfs \
    fuse-devel \
    fuse3-devel \
    fzf \
    genisoimage \
    ghostty \
    gparted \
    grc \
    hashcat \
    ksystemlog \
    liquidctl \
    neovim \
    nicstat \
    numactl \
    openrazer-daemon \
    openrgb \
    podman-machine \
    podman-tui \
    podmansh \
    qemu-kvm \
    rclone \
    restic \
    starship \
    sysprof \
    tiptop \
    ublue-setup-services \
    usbmuxd \
    util-linux \
    virt-manager \
    virt-viewer \
    yt-dlp \
    yt-dlp-zsh-completion \
    zoxide \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# disable repositories
for copr in ublue-os/packages ublue-os/staging
do dnf5 -y copr disable $copr
done && unset -v copr

dnf5 config-manager setopt "*fedora-multimedia*".enabled=0
dnf5 config-manager setopt brave-browser.enabled=0
dnf5 config-manager setopt docker-ce-stable.enabled=0
dnf5 config-manager setopt hardware_razer.enabled=0
dnf5 config-manager setopt terra.enabled=0
dnf5 config-manager setopt vscode.enabled=0

# enable bazzite virtualization
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

# install cursor cli
echo "Installing Cursor CLI..."
CLI_DIR="/tmp/cursor-cli"
mkdir -p "$CLI_DIR"
aria2c --dir="$CLI_DIR" --out="cursor-cli.tar.gz" --max-tries=3 --connect-timeout=30 "https://api2.cursor.sh/updates/download-latest?os=cli-alpine-x64"
tar xzvf "$CLI_DIR/cursor-cli.tar.gz" -C "$CLI_DIR"
install -m 0755 "$CLI_DIR/cursor" /usr/bin/cursor-cli
rm -fr "$CLI_DIR"

# install omnissa horizon client
echo "Installing Omnissa Horizon Client..."
HORIZON_VERSION="2506-8.16.0-16536624989"
HORIZON_URL="https://download3.omnissa.com/software/CART26FQ2_LIN_2506_TARBALL/Omnissa-Horizon-Client-Linux-$HORIZON_VERSION.tar.gz"
TMP_DIR="/tmp/horizon" ; mkdir -p "$TMP_DIR"
EXT_DIR="$TMP_DIR/Omnissa-Horizon-Client-Linux-$HORIZON_VERSION/x64"
aria2c --dir="$TMP_DIR" --out="Omnissa-Horizon-Client-Linux-$HORIZON_VERSION.tar.gz" --max-tries=3 --connect-timeout=30 "$HORIZON_URL"
tar xzvf "$TMP_DIR/Omnissa-Horizon-Client-Linux-$HORIZON_VERSION.tar.gz" -C "$TMP_DIR"
for component in "Client" "fileAssociation" "html5mmr" "integratedPrinting" "PCoIP" "scannerClient" "serialportClient" "USB"; do
  echo "Setting up Horizon component: $component ..."
  tar xzvf "$EXT_DIR/Omnissa-Horizon-$component-$HORIZON_VERSION.x64.tar.gz" -C "$TMP_DIR"
  cp -avR "$TMP_DIR/Omnissa-Horizon-$component-$HORIZON_VERSION.x64"/* /
  echo "Component '$component' setup complete."
done
rm -fr "$TMP_DIR"

# hide incompatible Bazzite just recipes
for recipe in "install-coolercontrol" "install-openrazer" "install-openrgb"; do
  if ! grep -l "^$recipe:" /usr/share/ublue-os/just/*.just | grep -q .; then
    echo "Error: Recipe $recipe not found in any just file"
    exit 1
  fi
  sed -i "s/^$recipe:/_$recipe:/" /usr/share/ublue-os/just/*.just
done

# remove zsh defaults
rm -fv /etc/skel/{.zshrc,.zprofile}

# workaround to allow ostree installation of Nix daemon
mkdir -pv /nix
