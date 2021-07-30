#!/bin/zsh

local zshrc_dir=''
if [ "$0" = "zsh" ] || [ "$0" = "-zsh" ] || [ "$0" = "/bin/zsh" ] || [ "$0" = "/usr/local/bin/zsh" ]; then
    zshrc_dir="$(dirname $(readlink $HOME/.zshrc))"
elif [ -n "$(readlink $0)" ]; then
    zshrc_dir="$(dirname $(readlink $0))"
else
    zshrc_dir="$(dirname $0)"
fi
if [ -z "$zshrc_dir" ]; then
    local message='zshrc_dir is empty.'
    echo -e "\e[31m$message\e[m"
    return 1
fi

pushd "$zshrc_dir" >/dev/null

local dotfiles_dir=$(git rev-parse --show-toplevel)
source $dotfiles_dir/colorize.sh
source $dotfiles_dir/env.sh
source $dotfiles_dir/util/func.sh
source $dotfiles_dir/alias.sh

popd >/dev/null

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

source $HOME/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

local xdg_dirs=(
    $XDG_CONFIG_HOME/aws
    $XDG_CONFIG_HOME/pg
    $XDG_CACHE_HOME/pg
    $XDG_DATA_HOME/cargo
    $XDG_CACHE_HOME/ccache
    $XDG_CONFIG_HOME/docker
    $XDG_DATA_HOME/go
    $XDG_DATA_HOME/gradle
    $XDG_CONFIG_HOME/irb
    $XDG_CONFIG_HOME/java
    $XDG_DATA_HOME/minikube
    $XDG_CACHE_HOME/node-gyp
    $XDG_CONFIG_HOME/npm
    $XDG_DATA_HOME/gem
    $XDG_CACHE_HOME/gem
    $XDG_DATA_HOME/rustup
    $XDG_DATA_HOME/vscode
)
for dir in $xdg_dirs; do
    if [ ! -d $dir ]; then
        mkdir $dir
    fi
done

case "${OSTYPE}" in
    darwin*)
        source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
        source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
        ;;
esac

eval "$(zoxide init zsh)"
