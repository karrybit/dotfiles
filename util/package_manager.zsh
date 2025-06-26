#!/bin/zsh

function update_all() {
    # Use subshell to limit scope of set -eo pipefail
    (
        set -eo pipefail

        # for mac
        pushd ~/dotfiles/homebrew
        brew bundle dump -vf
        brew upgrade
        brew autoremove
        brew cleanup
        popd

        # for Arch
        # yay -Syu
        # yay -Yc

        $DOTFILES_PATH/rust/install.sh
        gcloud components update

        for repo in $(ghq list); do
            ghq get --update --parallel "$repo"
        done
    )
}
