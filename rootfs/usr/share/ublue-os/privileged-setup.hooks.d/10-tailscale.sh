#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

source /usr/lib/ublue/setup-services/libsetup.sh

version-script tailscale privileged 1 || exit 0

set -xeuo pipefail

tailscale set --operator="$(getent passwd "$PKEXEC_UID" | cut -d: -f1)"
