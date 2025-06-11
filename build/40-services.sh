#!/usr/bin/env bash
set -eoux pipefail

echo "::group::Executing services.sh"
trap 'echo "::endgroup::"' EXIT

# enable systemd services
systemctl enable docker.service docker.socket
systemctl enable libvirtd.service
systemctl enable podman.service podman.socket
systemctl enable ublue-system-setup.service
systemctl --global enable ublue-user-setup.service

# random plymouth theme
readarray -t themes < <(find /ctx/rootfs/usr/share/plymouth/themes -maxdepth 1 -type d -printf '%P\n')
theme=${themes[ $RANDOM % ${#themes[@]} ]}
plymouth-set-default-theme $theme
