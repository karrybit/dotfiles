#!/bin/bash

while read package; do
    go install "$package@latest"
done <$DOTFILES_PATH/go/package.txt
