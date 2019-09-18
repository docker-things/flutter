FROM gui-apps-base:18.04
MAINTAINER Gabriel Ionescu <gabi.ionescu+dockerthings@protonmail.com>

# INSTALL DEPENDENCIES
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libglu1-mesa \
        libxtst6 \
        unzip \
        wget \
        screen \
        xz-utils \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && apt-get autoremove -y

# INSTALL DEPENDENCIES
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        qemu-kvm \
 && adduser $DOCKER_USERNAME kvm

# SET APPS PATH
ENV APPS_PATH "/home/$DOCKER_USERNAME/apps"

# ADD FLUTTER TO PATH
ENV PATH "$PATH:$APPS_PATH/flutter/bin"

# ADD MAIN LAUNCHER
COPY install/run.sh /run.sh

# ADD SCRIPTS
COPY install/bin /usr/bin

# PERMISSIONS
RUN chmod +x \
    /run.sh \
    /usr/bin/android-studio \
    /usr/bin/flutter-doctor

# SET USER
USER $DOCKER_USERNAME

# ENTRYPOINT
ENTRYPOINT ["/run.sh"]
