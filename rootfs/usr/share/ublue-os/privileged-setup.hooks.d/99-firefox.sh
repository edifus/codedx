#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

# shellcheck disable=SC1091
source /usr/lib/ublue/setup-services/libsetup.sh

version-script firefox-config privileged 1 || exit 0

set -x

# Set up Firefox default configuration
ARCH=$(arch)
if [ "$ARCH" != "aarch64" ] ; then
    mkdir -p "/var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/${ARCH}/stable/defaults/pref"
    rm -f "/var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/${ARCH}/stable/defaults/pref/*aurora*.js"
    /usr/bin/cp -rf /usr/share/applications/firefox-config/* "/var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/${ARCH}/stable/defaults/pref/"
fi