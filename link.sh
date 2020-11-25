#!/bin/bash

set -euox pipefail

ln -si ~/dotfiles/.zshenv ~/.zshenv
ln -si ~/dotfiles/.zsh ~/.zsh
source ~/.zshenv
source ~/.zsh/.zshrc

ln -si ~/dotfiles/git "$XDG_CONFIG_HOME"
ln -si ~/dotfiles/nvim "$XDG_CONFIG_HOME/nvim"
ln -si "$HOME/dotfiles/alacritty" "$XDG_CONFIG_HOME"
ln -si "$HOME/dotfiles/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
ln -si "$HOME/dotfiles/tmux" "$XDG_CONFIG_HOME/tmux"
ln -si ~/dotfiles/karabiner/karabiner.json "$XDG_CONFIG_HOME/karabiner/karabiner.json"
