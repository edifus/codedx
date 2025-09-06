#!/usr/bin/bash
#shellcheck disable=SC1091,SC2154

if [[ -z ${project_root} ]]; then
    project_root=$(git rev-parse --show-toplevel)
fi
. "${project_root}/just_scripts/sudoif.sh"

set -euox pipefail

sudoif rm -f "${project_root}"/just_scripts/output/* #ISOs
