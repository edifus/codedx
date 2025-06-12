#!/usr/bin/env bash
set -eoux pipefail

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

## Extra apps (built-in repos)
# bazzite
mkdir -pv /usr/share/gamescope-session-plus/
curl -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz
dnf5 install --enable-repo="copr:copr.fedorainfracloud.org:bazzite-org:bazzite" -y \
    gamescope-session-plus \
    gamescope-session-steam
