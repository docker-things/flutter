FROM gui-apps-base:21.04
MAINTAINER Gabriel Ionescu <gabi.ionescu+dockerthings@protonmail.com>

# INSTALL DEPENDENCIES
RUN echo " > Update repos" \
 && apt-get update \
 \
 && echo " > Install dependencies" \
 && apt-get install -y --no-install-recommends \
        software-properties-common \
        gpg-agent \
 && add-apt-repository -y ppa:git-core/ppa \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libglu1-mesa \
        libxtst6 \
        mesa-utils \
        openssh-client \
        iputils-ping \
        qemu-kvm \
        screen \
        sudo \
        scrcpy \
        zip \
        zipalign \
        unzip \
        wget \
        xz-utils \
 \
 && echo " > Install Google Chrome" \
 && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb \
 && apt install -y \
       /tmp/google-chrome.deb \
 \
 && echo " > Cleanup" \
 && rm -f /tmp/google-chrome.deb \
 && apt-get remove -y \
       software-properties-common \
       gpg-agent \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && apt-get autoremove -y

# SET APPS PATH
ENV APPS_PATH "/home/$DOCKER_USERNAME/apps"

# ADD FLUTTER & ADB TO PATH
ENV PATH "$PATH:$APPS_PATH/flutter/bin:/home/$DOCKER_USERNAME/Android/Sdk/platform-tools:/home/$DOCKER_USERNAME/apps/android-studio/jre/bin"

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
    /usr/bin/flutter-doctor \
 && sed -i 's/^kvm:x:107:.*$/kvm:x:107:'$DOCKER_USERNAME'/g' /etc/group \
 && sed -i 's/^render:x:108:.*$/render:x:108:'$DOCKER_USERNAME'/g' /etc/group


# Required for nvidia-docker v1
# RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
#     echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

# ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
# ENV NVIDIA_VISIBLE_DEVICES all
# ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
# ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"
# ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

# SET USER
USER $DOCKER_USERNAME

# ENTRYPOINT
ENTRYPOINT ["/run.sh"]
