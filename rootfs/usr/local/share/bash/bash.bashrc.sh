# shellcheck shell=bash
# shellcheck disable=SC1091

export OSH=/usr/local/share/oh-my-bash
export OSH_THEME="powerline-multiline"
export HYPHEN_INSENSITIVE="true"
export DISABLE_AUTO_UPDATE="true"
export ENABLE_CORRECTION="true"
export COMPLETION_WAITING_DOTS="true"
export HIST_STAMPS="yyyy-mm-dd"
export OSH_CUSTOM=/usr/local/share/oh-my-bash/custom

export completions=(
  git
  composer
  ssh
)

export aliases=(
  chmod
  general
  ls
  misc
)

export plugins=(
  git
  bashmarks
)

source "$OSH/oh-my-bash.sh"

export LANG=en_US.UTF-8
export EDITOR='nano'

if [ -f "/home/${USER}/.ssh/rsa_id" ]; then
    export SSH_KEY_PATH="/home/${USER}/.ssh/rsa_id"
fi

edit-bash-config() { $EDITOR ~/.bashrc; }
edit-oh-my-bash() { $EDITOR "$OSH/oh-my-bash"; }
src-oh-my-bash() { source "$OSH/oh-my-bash"; }
src-bashrc() { source ~/.bashrc; }

# bash parameter completion for the dotnet CLI
_dotnet_bash_complete()
{
  local word=${COMP_WORDS[COMP_CWORD]}
  local completions
  completions="$(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)"
  if [ $? -ne 0 ]; then
    completions=""
  fi

  # shellcheck disable=SC2207
  COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}
complete -f -F _dotnet_bash_complete dotnet
