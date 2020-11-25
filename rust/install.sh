#!/bin/bash

rustup update

while read component; do
    rustup component add "$component"
done <$DOTFILES_PATH/rust/component
while read package; do
    cargo install "$package"
done <$DOTFILES_PATH/rust/package
