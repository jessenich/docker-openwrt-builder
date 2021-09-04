ARG VARIANT=buster
FROM debian:"$VARIANT"

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME="root"
ARG USER_UID="auto"
ARG USER_GID="auto"

COPY ./lxfs /

RUN apt-get update && \
    /bin/bash /tmp/docker-build/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true";
RUN apt-get install -y \
        build-essential \
        ccache \
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
        zlib1g-dev && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/docker-build/;

RUN git clone --depth 1 https://github.com/jayanta525/rk3328-rock-pi-e.git /root/openwrt/
WORKDIR /root/openwrt

ENTRYPOINT [ "/sbin/entrypoint.sh" "/root/openwrt" ]