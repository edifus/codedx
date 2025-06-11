#!/usr/bin/bash
if [[ -z "${image}" ]]; then
    image=${default_image}
fi

if [[ -z "${target}" ]]; then
    target=${default_target}
elif [[ ${target} == "nvidia" ]]; then
    target="codedx-nvidia"
fi

valid_images=(
    bazzite
    bazzite-gnome
)
image=${image,,}
if [[ ! ${valid_images[*]} =~ ${image} ]]; then
    echo "Invalid image..."
    exit 1
fi

target=${target,,}
valid_targets=(
    codedx
    codedx-nvidia
)
if [[ ! ${valid_targets[*]} =~ ${target} ]]; then
    echo "Invalid target..."
    exit 1
fi

desktop=""
if [[ ${image} =~ "gnome" ]]; then
    desktop="-gnome"
fi
image="${target}${desktop}"
if [[ ${image} =~ "nvidia" ]]; then
    image="codedx${desktop}-nvidia"
fi
