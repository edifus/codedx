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
dnf5 config-manager addrepo --from-repofile="https://download.opensuse.org/repositories/home:paul4us/Fedora_42/home:paul4us.repo"
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
    genisoimage \
    ghostty \
    gparted \
    hashcat \
    inxi \
    klassy \
    ksystemlog \
    kvantum \
    liquidctl \
    neovim \
    nicstat \
    numactl \
    openrazer-daemon \
    openrgb \
    podman-machine \
    podman-tui \
    podmansh \
    python3-ramalama \
    qemu-kvm \
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
dnf5 config-manager setopt home_paul4us.enabled=0
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

# install mozilla firefox
echo "Installing Mozilla Firefox..."
FIREFOX_DIR="/tmp/firefox" ; mkdir -p "$FIREFOX_DIR"
aria2c \
  --connect-timeout=30 \
  --dir="$FIREFOX_DIR" \
  --max-tries=3 \
  --out="firefox-latest.tar.xz" \
    "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
tar xf "$FIREFOX_DIR/firefox-latest.tar.xz" -C "$FIREFOX_DIR"
mv "$FIREFOX_DIR/firefox" /opt && ln -s /opt/firefox/firefox /usr/bin/firefox
rm -fr "$FIREFOX_DIR"

# hide incompatible Bazzite just recipes
for recipe in "install-coolercontrol" "install-openrazer" "install-openrgb"; do
  if ! grep -l "^$recipe:" /usr/share/ublue-os/just/*.just | grep -q .; then
    echo "Error: Recipe $recipe not found in any just file"
    exit 1
  fi
  sed -i "s/^$recipe:/_$recipe:/" /usr/share/ublue-os/just/*.just
done

# block flatpaks for native apps
flatpakBlock='/usr/share/ublue-os/flatpak-blocklist'
bazaarBlock='/usr/share/ublue-os/bazaar/blocklist.txt'
flatpakInstall='/usr/share/ublue-os/bazzite/flatpak/install'
{
  echo -e '\ndeny com.brave.Browser/*'
  echo -e '\ndeny com.visualstudio.code/*'
  echo -e '\ndeny com.discordapp.Discord/*'
  echo -e '\ndeny io.neovim.nvim/*'
  echo -e '\ndeny org.mozilla.firefox/*'
  echo -e '\ndeny org.openrgb.OpenRGB/*'
  echo -e '\ndeny org.virt_manager.virt-manager/*'
} >> $flatpakBlock

{
  echo -e '\ncom.brave.Browser'
  echo -e '\ncom.visualstudio.code'
  echo -e '\ncom.discordapp.Discord'
  echo -e '\norg.mozilla.firefox'
  echo -e '\norg.virt_manager.virt-manager'
} >> $bazaarBlock

sed -i '/org.mozilla.firefox/d' $flatpakInstall

# remove zsh defaults
rm -fv /etc/skel/{.zshrc,.zprofile}

# workaround to allow ostree installation of Nix daemon
mkdir -pv /nix
