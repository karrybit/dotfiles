#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

source $HOME/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
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

export DOTFILES_PATH=~/dotfiles
source $DOTFILES_PATH/util/func.sh

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

# ----- ENV -----

# XDG
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export CARGO_HOME=$XDG_DATA_HOME/cargo
export CCACHE_CONFIGPATH=$XDG_CONFIG_HOME/ccache.config
export CCACHE_DIR=$XDG_CACHE_HOME/ccache
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
export GOPATH=$XDG_DATA_HOME/go
export GRADLE_USER_HOME=$XDG_DATA_HOME/gradle
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java
export MINIKUBE_HOME=$XDG_DATA_HOME/minikube
export MYSQL_HISTFILE=$XDG_DATA_HOME/mysql_history
export NODE_GYP_CACHE=$XDG_CACHE_HOME/node-gyp
export NODE_REPL_HISTORY=$XDG_DATA_HOME/node_repl_history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PSQLRC=$XDG_CONFIG_HOME/pg/psqlrc
export PSQL_HISTORY=$XDG_CACHE_HOME/pg/psql_history
export PGPASSFILE=$XDG_CONFIG_HOME/pg/pgpass
export PGSERVICEFILE=$XDG_CONFIG_HOME/pg/pg_service.conf
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export VSCODE_PORTABLE=$XDG_DATA_HOME/vscode

#
export PATH=$PATH:/usr/local/sbin

# protobuf
export PATH=$PATH:/usr/local/opt/protobuf/bin

# k8s
export KUBECONFIG=$HOME/.kube/config

# go
export PATH=$PATH:$GOPATH/bin

# java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-14.0.2.jdk/Contents/Home
export PATH=$PATH:$JAVA_HOME/bin

# rust
export PATH=$PATH:$CARGO_HOME/bin
export RUSTC_WRAPPER="$(which sccache)"

# ruby
[[ -d ~/.rbenv ]] &&
    export PATH=${HOME}/.rbenv/bin:${PATH} &&
    eval "$(rbenv init -)"

# node
[[ -d ~/.nodenv ]] &&
    export PATH=$PATH:$HOME/.nodenv/bin &&
    eval "$(nodenv init -)"

# ----- COLORIZE -----

# constants
ESC='\e['
ESC_END='m'
STYLE_END=${ESC}${ESC_END}

FONT_COLOR=3
BACKGROUND_COLOR=4

# colors
BLACK=0
RED=1
GREEN=2
YELLOW=3
BLUE=4
MAGENTA=5
CYAN=6
WHITE=7

FONT_BLACK=${FONT_COLOR}${BLACK}
FONT_RED=${FONT_COLOR}${RED}
FONT_GREEN=${FONT_COLOR}${GREEN}
FONT_YELLOW=${FONT_COLOR}${YELLOW}
FONT_BLUE=${FONT_COLOR}${BLUE}
FONT_MAGENTA=${FONT_COLOR}${MAGENTA}
FONT_CYAN=${FONT_COLOR}${CYAN}
FONT_WHITE=${FONT_COLOR}${WHITE}

BACKGROUND_BLACK=${BACKGROUND}${BLACK}
BACKGROUND_RED=${BACKGROUND}${RED}
BACKGROUND_GREEN=${BACKGROUND}${GREEN}
BACKGROUND_YELLOW=${BACKGROUND}${YELLOW}
BACKGROUND_BLUE=${BACKGROUND}${BLUE}
BACKGROUND_MAGENTA=${BACKGROUND}${MAGENTA}
BACKGROUND_CYAN=${BACKGROUND}${CYAN}
BACKGROUND_WHITE=${BACKGROUND}${WHITE}

# attributes
BOLD=1
UNDER_LINE=4
BLINK=5
REVERSE_VIDEO=7
INVISIBLE_TEXT=8

function reset_style() {
    echo -en ${STYLE_END}
}

function echo_success() {
    echo -en "${ESC}${FONT_GREEN}${ESC_END}$1${STYLE_END}"
}

function set_style_success() {
    echo -en "${ESC}${FONT_GREEN}${ESC_END}"
}

function echo_failure() {
    echo -en "${ESC}${FONT_RED}${ESC_END}$1${STYLE_END}"
}

function set_style_failure() {
    echo -en "${ESC}${FONT_RED}${ESC_END}"
}

function echo_processing() {
    echo -en "${ESC}${FONT_WHITE};${BLINK}${ESC_END}$1${STYLE_END}"
}

function set_style_processing() {
    echo -en "${ESC}${FONT_WHITE};${BLINK}${ESC_END}"
}

function echo_note() {
    echo -en "${ESC}${FONT_WHITE};${BOLD}${ESC_END}$1${STYLE_END}"
}

function set_style_note() {
    echo -en "${ESC}${FONT_WHITE};${BOLD}${ESC_END}"
}

# ----- ALIAS ----

alias ..='cd ..'
alias cat='bat'
alias l='exa -lbghHimSuU@ --time-style long-iso --git -s Name'
alias ls='exa -lbghHimSuU@ --time-style long-iso --git -s Name'
alias ll='exa -lbghHimSuU@ --time-style long-iso --git -s Name'
alias la='exa -labghHimSuU@ --time-style long-iso --git -s Name'
alias grep='rg'
alias find='fd'
alias vim='nvim'
alias top='glances'
alias du='dust -r -d 1'
alias df='duf'
alias tree='broot -hp'
alias sed='sd'
alias ping='gping'
alias ps='procs'
alias curl='curlie'

alias yq='yq eval -C'

# interpreter
alias gorepl='gore'
alias rustrepl='evcxr'

# kubernetes
alias k='kubectl'
alias kex='kubectl exec'
alias kg='kubectl get'
alias ked='kubectl edit'

# memo
alias mmn='memo new'
alias mme='memo edit'
