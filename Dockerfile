ARG VARIANT=buster
FROM debian:"$VARIANT"

COPY ./rootfs /

LABEL maintainer="Jesse N <jesse@keplerdev.com>" \
      org.opencontainers.image.source="https://github.com/jessenich/docker-openwrt-image-builder"

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        ccache \
        curl \
        ecj \
        fastjar \
        file \
        g++ \
        gawk \
        gettext \
        git \
        java-propose-classpath \
        libelf-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libssl-dev \
        python \
        python2.7-dev \
        python3 \
        unzip \
        wget \
        python3-distutils \
        python3-setuptools \
        python3-dev \
        rsync \
        subversion \
        swig \
        time \
        xsltproc \
        zlib1g-dev
    # Clean up
RUN apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/docker-build/;

RUN /bin/bash /usr/local/sbin/install-oh-my.sh --zsh --bash;

RUN git clone https://github.com/jayanta525/rk3328-rock-pi-e.git /root/openwrt/
WORKDIR /root/openwrt