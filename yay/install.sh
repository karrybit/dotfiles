#!/bin/bash

function install() {
    while read package; do
        yay -Syu $package
    done <$DOTFILES_PATH/yay/package
}

install
