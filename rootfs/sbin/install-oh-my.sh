#!/usr/bin/env bash

export OSH="/usr/local/share/bash/oh-my-bash";
export ZSH="/usr/local/share/zsh/oh-my-zsh";

apt-get update;
apt-get install zsh zsh-autosuggestions zsh-common zsh-syntax-highlighting git

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
/bin/bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if [ -d /root/.oh-my-bash ]; then
    mv /root/.oh-my-bash "${OSH}";
fi

if [ -d /root/.oh-my-zsh ]; then
    mv /root/.oh-my-zsh "${ZSH}";
fi

if [ -f /root/.bashrc.pre-oh-my-bash ]; then
    mv /root/.bashrc.pre-oh-my-bash /root/.bashrc
fi

if [ -f /root/.zshrc.pre-oh-my-zsh ]; then
    mv /root/.zshrc.pre-oh-my-zsh /root/.zshrc
fi

shells_update="$(cat /etc/shells | grep zsh)";
if [ -n "$shells_update" ]; then
    echo "/bin/zsh" >> /etc/shells;
fi
