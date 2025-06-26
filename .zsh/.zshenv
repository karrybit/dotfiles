#!/bin/zsh

# Input Japanese
export GTK_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
export QT_IM_MODULE=fcitx5

# export XDG base directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_BIN_HOME=$HOME/.local/bin

# make XDG base directory
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_BIN_HOME

# make XDG config directories
mkdir -p $XDG_CONFIG_HOME/aws
mkdir -p $XDG_CONFIG_HOME/docker
mkdir -p $XDG_CONFIG_HOME/java
mkdir -p $XDG_CONFIG_HOME/npm
mkdir -p $XDG_CONFIG_HOME/pg
mkdir -p $XDG_CONFIG_HOME/aquaproj-aqua

# export config path using XDG
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export CCACHE_CONFIGPATH=$XDG_CONFIG_HOME/ccache.config
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# make XDG cache directories
mkdir -p $XDG_CACHE_HOME/ccache
mkdir -p $XDG_CACHE_HOME/node-gyp
mkdir -p $XDG_CACHE_HOME/pg

# export cache path using XDG
export CCACHE_DIR=$XDG_CACHE_HOME/ccache
export NODE_GYP_CACHE=$XDG_CACHE_HOME/node-gyp
export PSQL_HISTORY=$XDG_CACHE_HOME/pg/psql_history

# make XDG data directories
mkdir -p $XDG_DATA_HOME/cargo
mkdir -p $XDG_DATA_HOME/go
mkdir -p $XDG_DATA_HOME/gradle
mkdir -p $XDG_DATA_HOME/rustup
mkdir -p $XDG_DATA_HOME/vscode

# export data path using XDG
export CARGO_HOME=$XDG_DATA_HOME/cargo
export GOPATH=$XDG_DATA_HOME/go
export GRADLE_USER_HOME=$XDG_DATA_HOME/gradle
export MYSQL_HISTFILE=$XDG_DATA_HOME/mysql_history
export NODE_REPL_HISTORY=$XDG_DATA_HOME/node_repl_history
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export VSCODE_PORTABLE=$XDG_DATA_HOME/vscode
export CLAUDE_CONFIG_DIR=$XDG_CONFIG_HOME/claude

# path
export PATH=/usr/local/sbin:$PATH
export PATH=$XDG_BIN_HOME:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH

# vim
export VIMINIT=":source $XDG_CONFIG_HOME"/nvim/vimrc

# protobuf
export PATH=$PATH:/usr/local/opt/protobuf/bin

# k8s
export KUBECONFIG=$HOME/.kube/config

# go
export PATH=$PATH:$GOPATH/bin
export GOPRIVATE=github.com/karrybit

# java
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# rust
export PATH=$PATH:$CARGO_HOME/bin

# volta
export VOLTA_HOME="$XDG_BIN_HOME/volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# dotfiles
export DOTFILES_PATH=~/dotfiles

# krew
export PATH="$PATH:$HOME/.krew/bin"

# zsh
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
export AQUA_PROGRESS_BAR=true

. "/Users/takumikaribe/.local/share/cargo/env"
