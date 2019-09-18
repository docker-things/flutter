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
APP_TERMINAL="true"
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

    -v $(pwd)/data/home:/home/$(whoami)

    -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse
    -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native

    -e FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.9.1+hotfix.2-stable.tar.xz"
    -e ANDROID_STUDIO_DOWNLOAD_URL="https://dl.google.com/dl/android/studio/ide-zips/3.5.0.21/android-studio-ide-191.5791312-linux.tar.gz"

    --rm
    -it
    )
