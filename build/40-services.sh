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

# starship shell prompt
# shellcheck disable=SC2016
echo 'eval "$(starship init bash)"' >> /etc/bashrc
