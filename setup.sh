#!/bin/bash

set -euox pipefail

# Check out dotfiles
cd ~
git clone https://github.com/karrybit/dotfiles.git

# Setup zsh
ln -si ~/dotfiles/.zshenv ~/.zshenv
ln -si ~/dotfiles/.zsh ~/.zsh
source ~/.zshenv
source ~/.zsh/.zshrc

# Link these tools
ln -si ~/dotfiles/git "$XDG_CONFIG_HOME"
ln -si ~/dotfiles/nvim "$XDG_CONFIG_HOME/nvim"
ln -si "$HOME/dotfiles/alacritty" "$XDG_CONFIG_HOME"
ln -si "$HOME/dotfiles/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
ln -si "$HOME/dotfiles/tmux" "$XDG_CONFIG_HOME/tmux"
ln -si ~/dotfiles/karabiner/karabiner.json "$XDG_CONFIG_HOME/karabiner/karabiner.json"

# Install the packages by Homebrew
cd ~/dotfiles/homebrew
./install.sh
cd ~

# Install the pacakges by go
cd ~/dotiles/go
./install.sh
cd ~

# https://doc.rust-lang.org/cargo/getting-started/installation.html
curl https://sh.rustup.rs -sSf | sh
# Install the crates by cargo
cd ~/dotfiles/rust
./install.sh
cd ~

# Install alacritty
mkdir -p ~/work/ghq
ghq get https://github.com/alacritty/alacritty.git
cd $(ghq list --full-path alacritty)
tag_name="$(git describe --tags --exact-match)"
git switch --detach "$(gh release list --exclude-pre-releases --exclude-drafts --limit 1 --json tagName --jq '.[0].tagName')"
switched_tag_name="$(git describe --tags --exact-match)"
if [ "${tag_name}" != "${switched_tag_name}" ]; then
    make app
    cp -r target/release/osx/Alacritty.app /Applications/
    ./target/release/osx/Alacritty.app/Contents/MacOS/alacritty migrate
fi

# Setup gcloud
gcloud auth login
