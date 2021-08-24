#!/bin/bash

source "$DOTFILES_PATH/util/docker.sh"
source "$DOTFILES_PATH/util/ghq.sh"
source "$DOTFILES_PATH/util/git.sh"
source "$DOTFILES_PATH/util/kubectl.sh"
source "$DOTFILES_PATH/util/launch_app.sh"
source "$DOTFILES_PATH/util/memo.sh"
source "$DOTFILES_PATH/util/navigation.sh"
source "$DOTFILES_PATH/util/package_manager.sh"

function lg() {
    la | grep "$1"
}

function ports() {
    if [ $# -eq 0 ]; then
        lsof -i -P
    elif [ $# -eq 1 ]; then
        lsof -i -P | grep "$1"
    else
        echo_failure 'argument number should be 1 or 0.\n'
    fi
}
