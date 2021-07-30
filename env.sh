#!/bin/bash

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export CARGO_HOME=$XDG_DATA_HOME/cargo
export CCACHE_CONFIGPATH=$XDG_CONFIG_HOME/ccache.config
export CCACHE_DIR=$XDG_CACHE_HOME/ccache
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
export GOPATH=$XDG_DATA_HOME/go
export GRADLE_USER_HOME=$XDG_DATA_HOME/gradle
export IRBRC=$XDG_CONFIG_HOME/irb/irbrc
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
export GEM_HOME=$XDG_DATA_HOME/gem
export GEM_SPEC_CACHE=$XDG_CACHE_HOME/gem
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

# ghq
export GHQ_ROOT="$(ghq root)"
export DOTFILES_PATH="$(ghq list --full-path | grep karrybit/dotfiles)"

# wasm
export PATH=$PATH:$HOME/wabt/build
