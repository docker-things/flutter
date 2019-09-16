FROM gui-apps-base:18.04
MAINTAINER Gabriel Ionescu <gabi.ionescu+dockerthings@protonmail.com>

ENV PATH "$PATH:/home/$DOCKER_USERNAME/dev/flutter/bin"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libglu1-mesa \
        libxtst6 \
        unzip \
        wget \
        xz-utils \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && apt-get autoremove -y

RUN mkdir -p /home/$DOCKER_USERNAME/dev \
 && chown $DOCKER_USERNAME:$DOCKER_GROUPID -R /home/$DOCKER_USERNAME

# SET USER
USER $DOCKER_USERNAME

ARG FLUTTER_DOWNLOAD_URL
RUN cd /home/$DOCKER_USERNAME/dev \
 && wget $FLUTTER_DOWNLOAD_URL -O flutter.tar.xz \
 && tar xvf flutter.tar.xz \
 && rm -f flutter.tar.xz

ARG ANDROID_STUDIO_DOWNLOAD_URL
RUN cd /home/$DOCKER_USERNAME/dev \
 && wget "$ANDROID_STUDIO_DOWNLOAD_URL" -O android-studio.tar.gz \
 && tar -xvf android-studio.tar.gz \
 && rm -f android-studio.tar.gz

RUN flutter config --no-analytics

RUN flutter precache

RUN flutter doctor


# ENV LIBGL_ALWAYS_SOFTWARE 1
# ENV LIBGL_DEBUG verbose

# ENTRYPOINT
ENTRYPOINT ["/bin/bash"]
# ENTRYPOINT ["/usr/bin/firefox"]
