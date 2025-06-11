#!/usr/bin/env bash
set -eoux pipefail

echo "::group::Executing fix-opt.sh"
trap 'echo "::endgroup::"' EXIT

# Move directories from /var/opt to /usr/lib/opt
for dir in /var/opt/*/; do
  [ -d "$dir" ] || continue
  dirname=$(basename "$dir")
  mv -v "$dir" "/usr/lib/opt/$dirname"
  echo "L+ /var/opt/$dirname - - - - /usr/lib/opt/$dirname" >>/usr/lib/tmpfiles.d/opt-fix.conf
done
