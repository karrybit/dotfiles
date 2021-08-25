#!/bin/bash

function link_zsh() {
    echo_success 'link '
    reset_style
    echo "$HOME/.zshrc -> $DOTFILES_PATH/zsh/.zshrc"
    ln -si "$DOTFILES_PATH/zsh/.zshrc" "$HOME"
}

function link_vim() {
    echo_success 'link '
    reset_style
    echo "$HOME/.vimrc -> $DOTFILES_PATH/vim/.vimrc"
    ln -si "$DOTFILES_PATH/vim/.vimrc" "$HOME"
}

function link_p10k() {
    echo_success 'link '
    reset_style
    echo "$HOME/.p10k.zsh -> $DOTFILES_PATH/p10k/.p10k.zsh"
    ln -si "$DOTFILES_PATH/p10k/.p10k.zsh" "$HOME"
}

function link_git() {
    if [ ! -d "$XDG_CONFIG_HOME" ]; then
        mkdir -p "$XDG_CONFIG_HOME"
    fi
    echo_success 'link '
    reset_style
    echo "$XDG_CONFIG_HOME/git -> $DOTFILES_PATH/git"
    ln -si "$DOTFILES_PATH/git" "$XDG_CONFIG_HOME"
}

function link_karabiner() {
    if [ ! -d "$XDG_CONFIG_HOME/karabiner" ]; then
        mkdir -p "$XDG_CONFIG_HOME/karabiner"
    fi
    echo_success 'link '
    reset_style
    echo "$XDG_CONFIG_HOME/karabiner/karabiner.json -> $DOTFILES_PATH/karabiner/karabiner.json"
    ln -si "$DOTFILES_PATH/karabiner/karabiner.json" "$XDG_CONFIG_HOME/karabiner"
}

function link_iterm2() {
    if [ ! -d "$XDG_CONFIG_HOME/iterm2" ]; then
        mkdir -p "$XDG_CONFIG_HOME/iterm2"
    fi
    echo_success 'link '
    reset_style
    echo "$XDG_CONFIG_HOME/iterm2/theme.itermcolors -> $DOTFILES_PATH/iterm2/theme.itermcolors"
    ln -si "$DOTFILES_PATH/iterm2/theme.itermcolors" "$XDG_CONFIG_HOME/iterm2"
}

link_zsh
link_vim
link_p10k
link_git
link_karabiner
link_iterm2
