#!/bin/bash

# Command used to launch docker
DOCKER_CMD="`which docker`"

# Where to store the backups
BACKUP_PATH=""

# Where to store the communication pipes
FIFO_PATH="/tmp/docker-things/fifo"

# The name of the docker image
PROJECT_NAME="flutter"

# Meta to set in the .desktop file
APP_GENERIC_NAME="IDE"
APP_CATEGORIES="Development;IDE;"
APP_TERMINAL="false"
APP_MIME_TYPE="text/plain;"
APP_PARAM="%f"

# BUILD ARGS
BUILD_ARGS=(
    )

# LAUNCH ARGS
RUN_ARGS=(
    -h $PROJECT_NAME

    -e DISPLAY=$DISPLAY
    -v /tmp/.X11-unix:/tmp/.X11-unix

    -v $XAUTHORITY:/tmp/.Xauthority
    -e XAUTHORITY=/tmp/.Xauthority

    --memory="10g"
    --cpu-shares=1024
    --shm-size 2g

    --privileged

    # --gpus all

    --device=/dev/kvm

    --device=/dev/dri/card0:/dev/dri/card0
    --device /dev/dri/renderD128:/dev/dri/renderD128

    -v $HOME:/home/host
    -v $(pwd)/data/home:/home/$(whoami)

    -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse
    -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native

    -e FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.9.1+hotfix.2-stable.tar.xz"
    -e ANDROID_STUDIO_DOWNLOAD_URL="https://dl.google.com/dl/android/studio/ide-zips/3.5.0.21/android-studio-ide-191.5791312-linux.tar.gz"

    --rm
    -d
    )

# NVIDIA REQUIRED - HARDWARE ACCELERATION
# distribution="$(. /etc/os-release;echo $ID$VERSION_ID)"
# if [ "$distribution" == "elementary5.0" ]; then
#     distribution="ubuntu18.04"
# fi

# curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
# curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
# sudo systemctl restart docker
