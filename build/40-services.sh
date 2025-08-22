#!/usr/bin/env bash
set -eoux pipefail

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

# enable systemd services
systemctl --global enable codedx-user-vscode.service
systemctl --global enable ublue-user-setup.service
systemctl enable bazzite-libvirtd-setup.service
systemctl enable codedx-groups.service
systemctl enable docker.service docker.socket
systemctl enable podman.service podman.socket
systemctl enable ublue-system-setup.service

# random plymouth theme
#eadarray -t themes < <(find /ctx/rootfs/usr/share/plymouth/themes -maxdepth 1 -type d -printf '%P\n')
#theme=${themes[ $RANDOM % ${#themes[@]} ]}
#plymouth-set-default-theme $theme

# kde ksysguard caps
[[ ${BASE_IMAGE_NAME} == 'kinoite' ]] && \
    setcap 'cap_net_raw+ep' /usr/libexec/ksysguard/ksgrd_network_helper || true

# Restore UUPD update timer and Input Remapper
sed -i 's@^NoDisplay=true@NoDisplay=false@' /usr/share/applications/input-remapper-gtk.desktop
systemctl enable input-remapper.service
systemctl enable uupd.timer

# Remove -deck specific changes to allow for login screens
rm -f /etc/sddm.conf.d/steamos.conf
rm -f /etc/sddm.conf.d/virtualkbd.conf
rm -f /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz
systemctl disable bazzite-autologin.service

if [[ "$IMAGE_NAME" == *gnome* ]]; then
    # Remove SDDM and re-enable GDM on GNOME builds.
    dnf5 remove -y sddm
    systemctl enable gdm.service
else
    # Re-enable logout and switch user functionality in KDE
    sed -i -E \
      -e 's/^(action\/switch_user)=false/\1=true/' \
      -e 's/^(action\/start_new_session)=false/\1=true/' \
      -e 's/^(action\/lock_screen)=false/\1=true/' \
      -e 's/^(kcm_sddm\.desktop)=false/\1=true/' \
      -e 's/^(kcm_plymouth\.desktop)=false/\1=true/' \
      /etc/xdg/kdeglobals
fi

# starship shell prompt
# shellcheck disable=SC2016
echo 'eval "$(starship init bash)"' >> /etc/bashrc
