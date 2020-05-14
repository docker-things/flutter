#!/bin/bash

# If we've got params
if [ "$1" != "" ]; then
    android-studio $@
    exit
fi

# Output functions
function showNormal() { echo -e "\033[00m$@"; }
function showGreen() { echo -e "\033[01;32m$@\033[00m"; }
function showYellow() { echo -e "\033[01;33m$@\033[00m"; }
function showRed() { echo -e "\033[01;31m$@\033[00m"; }

# Create .bashrc if not present
if [ ! -f ~/.bashrc ]; then
    showGreen "\nCREATE .bashrc"
    cp /etc/skel/.bashrc ~/
    sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" ~/.bashrc
fi

# Create apps dir
if [ ! -d $APPS_PATH ]; then
    showGreen "\nCREATE APPS DIR"
    mkdir -p $APPS_PATH
fi

# Install android studio
if [ ! -d $APPS_PATH/android-studio ]; then
    showYellow "\n[ANDROID-STUDIO] App not found. Will be installed!"
    cd $APPS_PATH
    if [ ! -f android-studio.tar.gz ]; then
        showGreen "\n[ANDROID-STUDIO] Download"
        wget "$ANDROID_STUDIO_DOWNLOAD_URL" -O android-studio.tar.gz
        if [ ! -f android-studio.tar.gz ]; then
            showRed "\n[ANDROID-STUDIO][ERROR] Couldn't download from \"$ANDROID_STUDIO_DOWNLOAD_URL\""
            exit 1
        fi
    fi
    showGreen "\n[ANDROID-STUDIO] Extract archive"
    tar xvf android-studio.tar.gz
    if [ ! -d $APPS_PATH/android-studio ]; then
        showRed "\n[ANDROID-STUDIO][ERROR] Couldn't extract archive!"
        exit 1
    fi

    showGreen "\n[ANDROID-STUDIO] Remove archive"
    rm -f android-studio.tar.gz

    showGreen "\n[ANDROID-STUDIO] Done"
fi

# Install flutter
if [ ! -d $APPS_PATH/flutter ]; then
    showYellow "\n[FLUTTER] App not found. Will be installed!"
    cd $APPS_PATH
    if [ ! -f flutter.tar.gz ]; then
        showGreen "\n[FLUTTER] Download"
        wget "$FLUTTER_DOWNLOAD_URL" -O flutter.tar.xz
        if [ ! -f flutter.tar.xz ]; then
            showRed "\n[FLUTTER][ERROR] Couldn't download from \"$FLUTTER_DOWNLOAD_URL\""
            exit 1
        fi
    fi
    showGreen "\n[FLUTTER] Extract archive"
    tar xvf flutter.tar.xz
    if [ ! -d $APPS_PATH/flutter ]; then
        showRed "\n[FLUTTER][ERROR] Couldn't extract archive!"
        exit 1
    fi

    showGreen "\n[FLUTTER] Remove archive"
    rm -f flutter.tar.xz

    showGreen "\n[FLUTTER] Deactivate analytics"
    flutter config --no-analytics

    showGreen "\n[FLUTTER] Precache"
    flutter precache

    showGreen "\n[FLUTTER] Check status"
    flutter doctor

    showGreen "\n[FLUTTER] Done"
fi

# Make sure screens start in the home dir
cd

# Set hostname as the screen daemon name
SCREEN_NAME="flutter"

# Launch daemon
showGreen "Launch screen daemon"
screen -dmS "$SCREEN_NAME" -t "$SCREEN_NAME" -s /bin/bash

# Keep the process id
SCREEN_PID="`ps ax | grep screen | grep -v grep | awk '{print $1}'`"

# Services to launch
SERVICES=(
    android-studio
    android-emulator
    flutter-doctor
    )

# Launch services
i=0
for service in ${SERVICES[@]} ; do
    i=$((i+1))
    showGreen "Launch $service screen [$i]"
    screen -S "$SCREEN_NAME" -X screen -t "$service"
    screen -S "$SCREEN_NAME" -p $i -X stuff $''${service}$'\r'
done

# Close first unused screen
showGreen "Close the first unused screen"
screen -S "$SCREEN_NAME" -p 0 -X stuff $'exit\r'

# Get kvm access
showGreen "Get kvm access"
sudo chown $DOCKER_USERNAME /dev/kvm

# Connect to screen
showGreen "Connect to screen"
screen -R
showGreen "Disconnected from screen"
