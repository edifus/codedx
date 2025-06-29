#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

# shellcheck disable=SC1091
source /usr/lib/ublue/setup-services/libsetup.sh

version-script qemu-home privileged 1 || exit 0

set -x

mapfile -t wheelarray < <(getent group wheel | cut -d ":" -f 4 | tr ',' '\n')
for user in "${wheelarray[@]}"; do
    setfacl -m u:qemu:rx "/home/$user"
done
