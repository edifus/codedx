#!/usr/bin/env bash
set -eoux pipefail

echo "::group::Executing build-initramfs.sh"
trap 'echo "::endgroup::"' EXIT

QUALIFIED_KERNEL="$(dnf5 repoquery --installed --queryformat='%{evr}.%{arch}' kernel)"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible --zstd -v --add ostree -f "/usr/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

chmod -v 0600 /usr/lib/modules/"$QUALIFIED_KERNEL"/initramfs.img
