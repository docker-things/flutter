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
        mesa-utils \
        qemu-kvm \
        screen \
        sudo \
        unzip \
        wget \
        xz-utils \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && apt-get autoremove -y

# SET APPS PATH
ENV APPS_PATH "/home/$DOCKER_USERNAME/apps"

# ADD FLUTTER TO PATH
ENV PATH "$PATH:$APPS_PATH/flutter/bin"

ENV QT_X11_NO_MITSHM 1

# ADD MAIN LAUNCHER
COPY install/run.sh /run.sh

# ADD SCRIPTS
COPY install/bin /usr/bin

# PERMISSIONS
RUN chmod +x \
    /run.sh \
    /usr/bin/android-studio \
    /usr/bin/android-emulator \
    /usr/bin/flutter-doctor

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64


# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

# SET USER
USER $DOCKER_USERNAME

# ENTRYPOINT
ENTRYPOINT ["/run.sh"]
