#!/usr/bin/env bash
set -eoux pipefail

echo "::group:: ===$(basename "$0")==="
trap 'echo "::endgroup::"' EXIT

dnf5 clean all
rm -frv /tmp/* || true

ostree container commit
