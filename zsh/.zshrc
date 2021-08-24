#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

export DOTFILES_PATH=~/dotfiles
source $DOTFILES_PATH/colorize.sh
source $DOTFILES_PATH/env.sh
source $DOTFILES_PATH/util/func.sh
source $DOTFILES_PATH/alias.sh

source $HOME/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

export XDG_CONFIG_HOME=$HOME/.config
if [ ! -d $XDG_CONFIG_HOME ]; then
    mkdir $XDG_CONFIG_HOME
fi
export XDG_CACHE_HOME=$HOME/.cache
if [ ! -d $XDG_CACHE_HOME ]; then
mkdir $XDG_CACHE_HOME
fi
export XDG_DATA_HOME=$HOME/.local/share
if [ ! -d $HOME/.local/share ]; then
    if [ ! -d $HOME/.local ]; then
        mkdir $HOME/.local
    fi
    mkdir $HOME/.local/share
fi

local xdg_dirs=(
    $XDG_CONFIG_HOME/aws
    $XDG_CONFIG_HOME/pg
    $XDG_CACHE_HOME/pg
    $XDG_DATA_HOME/cargo
    $XDG_CACHE_HOME/ccache
    $XDG_CONFIG_HOME/docker
    $XDG_DATA_HOME/go
    $XDG_DATA_HOME/gradle
    $XDG_CONFIG_HOME/java
    $XDG_DATA_HOME/minikube
    $XDG_CACHE_HOME/node-gyp
    $XDG_CONFIG_HOME/npm
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
