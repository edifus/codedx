#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

mapfile -t wheelarray < <(getent group wheel | cut -d ":" -f 4 | tr ',' '\n')
for user in "${wheelarray[@]}"; do
    setfacl -m u:qemu:rx "/home/$user"
done
