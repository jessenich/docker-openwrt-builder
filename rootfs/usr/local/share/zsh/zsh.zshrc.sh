# shellcheck shell=bash
# shellcheck disable=SC1091,SC2034

if [ -d "$HOME/bin" ]; then
  export PATH=$HOME/bin:/usr/local/bin:$PATH;
fi

export ZSH=/usr/share/zsh/oh-my-zsh
export ZSH_THEME="agnoster"
export DISABLE_AUTO_UPDATE="true"
export DISABLE_UPDATE_PROMPT="true"
export HYPHEN_INSENSITIVE="true"
export DISABLE_AUTO_UPDATE="true"
export ENABLE_CORRECTION="true"
export COMPLETION_WAITING_DOTS="true"
export HIST_STAMPS="yyyy-mm-dd"
export ZSH_CUSTOM=/usr/share/zsh/oh-my-zsh/custom

export plugins=(
  alias
  alias-finder
  colored-man-pages
  docker
  docker-compose
  debian
  dotenv
  dotnet
  node
  npm
  npx
  nvm
  gpg-agent
  jsontools
  sudo
  systemd
  themes
  timer
  universalarchive
  vscode
  zsh_reload
)

source "$ZSH/oh-my-zsh.sh"
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export EDITOR='nano'

edit-zsh-config() { "$EDITOR ~/.zshrc"; }
edit-oh-my-zsh() { "$EDITOR $ZSH/oh-my-zsh"; }
src-oh-my-zsh() { "source $ZSH/oh-my-zsh"; }
src-zshrc() { "source ~/.zshrc"; }

# zsh parameter completion for the dotnet CLI
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")");
  reply=( "${(ps:\n:)completions}" );
}
compctl -K _dotnet_zsh_complete dotnet;
