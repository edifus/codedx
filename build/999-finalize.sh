#!/usr/bin/env bash
set -eoux pipefail

echo "::group::Executing finalize.sh"
trap 'echo "::endgroup::"' EXIT

dnf5 clean all
rm -frv /tmp/* || true
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -frv {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -frv {} \;
mkdir -pv /var/tmp
chmod -Rv 1777 /var/tmp

ostree container commit
