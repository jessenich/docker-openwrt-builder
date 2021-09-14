#!/usr/bin/env bash

install_zsh= ;
install_bash= ;
install_posh= ;
verbose=false;
marker_file=/etc/marker;

read_marker() {
    # Load markers to see which steps have already run
    if [ -f "${marker_file}" ]; then
        test "$verbose" = "true" && 
            echo "Marker file found: "

        cat "${marker_file}"
        source "${marker_file}"
    fi
}

write_marker() {
    # Write marker file
    mkdir -p "$(dirname "${marker_file}")"
    echo -e "\
        install_bash=(!($install_bash))\n\
        install_zsh=(!($install_zsh))\n\
        install_posh=(!($install_posh))" > "${marker_file}"
}

# Read markers prior to parsing args. Args should override any previous installations.
read_marker;

while [ "$#" -gt 0 ]; do
    case "$1" in
        -z | --zsh | --oh-my-zsh)
            install_zsh="true";
            shift;;

        -b | --bash | --oh-my-bash)
            install_bash="true";
            shift;;

        -p | --posh | --oh-my-posh)
            install_posh="true";
            shift;;
    esac
done

if [ ! "$install_bash" ] && [ ! "$install_zsh" ] && [ ! "$install_posh" ]; then
    echo "Nothing to install..."
    exit 0;
fi

apt-get update;
apt-get install -y git curl;


if [ "$install_bash" = "true" ]; then
    export OSH="/usr/local/share/bash/oh-my-bash";
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" && \
        rm /root/.bashrc /root/.bashrc.pre-oh-my-bash 2>/dev/null

    if [ -d /root/.oh-my-bash ]; then
        mv /root/.oh-my-bash "${OSH}";
    fi

    if [ -f /root/.bashrc.pre-oh-my-bash ]; then
        mv /root/.bashrc.pre-oh-my-bash /root/.bashrc
    fi

    cp /etc/defaults/bash/bashrc_template /root/.bashrc
    cp /etc/defaults/.profile /root/.profile
fi

if [ "$install_zsh" = "true" ]; then
    export ZSH="/usr/local/share/zsh/oh-my-zsh";
    apt-get install -y zsh 
    /bin/bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
        rm /root/.zshrc /root/.zshrc.pre-oh-my-zsh 2>/dev/null

    if [ -d /root/.oh-my-zsh ]; then
        mv /root/.oh-my-zsh "${ZSH}";
    fi

    if [ -f /root/.zshrc.pre-oh-my-zsh ]; then
        mv /root/.zshrc.pre-oh-my-zsh /root/.zshrc
    fi

    shells_update="$(grep zsh /etc/shells)";
    if [ -z "$shells_update" ]; then
        echo "/bin/zsh" >> /etc/shells;
    fi

    cp /etc/defaults/zsh/zshrc_template /root/.zshrc
fi

if [ "$install_posh" = "true" ]; then
    pwsh -NoProfile -NonInteractive -NoLogo -File /usr/local/sbin/Install-DefaultModules.ps1
fi

write_marker