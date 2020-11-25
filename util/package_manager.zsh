#!/bin/zsh

function update_all() {
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

    $DOTFILES_PATH/go/install.sh
    $DOTFILES_PATH/rust/install.sh
    gcloud components update

    for repo in $(ghq list); do
        ghq get --update --parallel "$repo"
    done

    # alacritty
    pushd $(ghq list --full-path alacritty)
    local tag_name="$(git describe --tags --exact-match)"
    git switch --detach "$(gh release list --exclude-pre-releases --exclude-drafts --limit 1 --json tagName --jq '.[0].tagName')"
    local switched_tag_name="$(git describe --tags --exact-match)"
    if [ "${tag_name}" != "${switched_tag_name}" ]; then
        make app
        cp -r target/release/osx/Alacritty.app /Applications/
    fi
    popd
}
