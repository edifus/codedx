#                                %@@@@@@@@@@@%
#                          @@@@@@#-----------*@@@@@
#                     @@@@%%-----===========-=---=#%@@
#                   @@@======---------------------====%@@
#                 @@#====-----------------------------=-=#@@
#              @@@%==-------------------------------**---==#@@
#             @@#==------------------------------------**--=-@@
#            @%==---------------------------------------***---#@@
#          @@*==-----------------------------------------*-*-==-@@
#         @@#==------------------------------------------**-*--==#@
#        @@#==---------------------------------------------***--==#@
#        @#-=----------------------------------------------*-**--=%@
#       @#-==--#%*=----------=-%%*--------------------------*-**--=%@
#       @--=----@@%-----------%@@---------------------------**-*--==@
#      @*==------%%*#%%%%%%%#*%%----------------------------**-*--==@
#     @@===------%%=+@@@@@@@+=%%--------------------------**-****-==@
#  @@--%===------%%=+%-----%+=%%-----------------==#@%%%#@%#+-***-=-%@
# @%=-*#==-------%%=+%-----%+=%%----------------#%%--====-*=#*-**--==@@
# @%=-%-=--------*#@%------#@%*----------------#===------**-#*-*-*--==#@
#  @@=%-==-------------------------------------=--------**=%#**-***-=-#@
#   @@@-==--------------------------------------------**-=@#-**-**--==*%@
#     @-=-------=-------=----------------------------**--@*--*-**-**-=--@
#     @-==------%%#=-@@@@#=-%%----------------------**-#%----**-*-*--=--@@
#     @#==----=-@%#==-###*==*%@------------------------#%----*-***-**--==@
#      @===----@%###=#####*-##%@#------------------=*@#------*--*-**---==@
#      @===----@%#############%@#-----------------%%#=-------***-**-*--==#@
#      @===----@%#############%@#---------------------------**-**-*-**--=-@
#      @@-==---@%#############%@#---------------------------*--**-**--*--=-@@
#       @-==---@%#############%@#--------------------------***-**-***-**--==@@@
#       @@#-=--@%--###%##%##*-%@#--------------------------***-**-****----=== @@@
#        @%-==- @#-*%%%%%%%#-#@ *------------------------**--*--------====-*@@@
#         @@-=-------------------------------------------**-*--===----#@@@@@
#          @@-=-----------------------------------------*-***--==%@@@@%@
#           @@#==--------------------------------------**-**-*---=-@@
#             @@-==-----------------------------------**-**--***--==@@
#              @@%*-=--------------------------------**-*****---=-=#-@@@
#                @@@===---------------------------**-*-------===-@@@@
#                  @@%%--====------------------*------=====-=%%@@
#                    @@@@%--======-=--=----------=====----@@@@
#                         @@@@@@@*---------------@@@@@@@@
#                                @@@@@@@@@@@@@@@@@
#
# Welcome to CodeDX! If you're looking to build your own,
# we highly recommend you use the ublue-os custom image template.
#
# https://github.com/ublue-os/image-template

ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG BASE_IMAGE_FLAVOR="${BASE_IMAGE_FLAVOR:-main}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG NVIDIA_FLAVOR="${NVIDIA_FLAVOR:-nvidia}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-bazzite}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.12.5-204.bazzite.fc41.x86_64}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-bazzite}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"
ARG FEDORA_VERSION="${FEDORA_VERSION:-41}"
ARG SHA_HEAD_SHORT="${SHA_HEAD_SHORT}"
ARG VERSION_TAG="${VERSION_TAG}"
ARG VERSION_PRETTY="${VERSION_PRETTY}"

####################
# BUILD ESSENTIALS
####################

FROM scratch AS ctx

COPY build /build
COPY rootfs /rootfs

####################
# CONTAINER BUILDS
####################

FROM ${BASE_IMAGE}:${FEDORA_VERSION} AS codedx

ARG IMAGE_NAME="${IMAGE_NAME:-codedx}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-edifus}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG NVIDIA_FLAVOR="${NVIDIA_FLAVOR:-nvidia}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-bazzite}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.12.5-204.bazzite.fc41.x86_64}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-main}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG FEDORA_VERSION="${FEDORA_VERSION:-41}"
ARG SHA_HEAD_SHORT="${SHA_HEAD_SHORT}"
ARG VERSION_TAG="${VERSION_TAG}"
ARG VERSION_PRETTY="${VERSION_PRETTY}"

COPY rootfs/ /

# install extra apps
RUN \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/20-install-apps.sh && \
    /ctx/build/40-services.sh && \
    /ctx/build/50-fix-opt.sh && \
    /ctx/build/99-cleanup.sh

# finalize container
RUN \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/60-image-info.sh && \
    /ctx/build/61-build-initramfs.sh && \
    /ctx/build/99-cleanup.sh && \
    /ctx/build/999-finalize.sh

RUN \
    dnf5 config-manager setopt skip_if_unavailable=1 && \
    bootc container lint
