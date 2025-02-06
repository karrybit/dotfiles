#!/bin/zsh

source "$DOTFILES_PATH/util/navigation.zsh"
source "$DOTFILES_PATH/util/package_manager.zsh"

case "${OSTYPE}" in
darwin*)
    source "$DOTFILES_PATH/util/darwin.zsh"
    ;;
linux*)
    source "$DOTFILES_PATH/util/linux.zsh"
    ;;
esac

function cargo_clean_cache() {
    set -x
    rm -rf $CARGO_HOME/git
    rm -rf $CARGO_HOME/registry
    rm -rf $(sccache -s | grep 'Cache location' | awk '{print $5}' | sed -e 's/^"//g; s/"$//g')
    set +x
}

function mktempf() {
    local tmp_file=$(mktemp)
    local file_name=$(basename $tmp_file)
    ln -s "$tmp_file" "./$file_name"
}

function mktempd() {
    if [ -z $1 ]; then
        return
    fi
    ln -s "$(mktemp -d)" "./$1"
}

function uuid() {
    case $OSTYPE in
    darwin*) uuidgen | tr "[:upper:]" "[:lower:]" | xargs echo -n | pbcopy ;;
    linux*) uuidgen | tr "[:upper:]" "[:lower:]" | xargs echo -n | pbcopyx ;;
    esac
}

function now() {
    case $OSTYPE in
    darwin*) echo 'not implemented' ;;
    linux*) date -Iseconds | xargs echo ;;
    esac
}

function nowc() {
    case $OSTYPE in
    darwin*) echo 'not implemented' ;;
    linux*) date -Iseconds | xargs echo -n | pbcopyx ;;
    esac
}

function now_utc() {
    case $OSTYPE in
    darwin*) echo 'not implemented' ;;
    linux*) date -Iseconds -u | xargs echo ;;
    esac
}

function now_utcc() {
    case $OSTYPE in
    darwin*) echo 'not implemented' ;;
    linux*) date -Iseconds -u | xargs echo -n | pbcopyx ;;
    esac
}

function ghqco() {
    organization=$1
    repository=$(gh repo list "${organization}" --no-archived --limit 200 --json url,updatedAt --jq '[.[] | select((.updatedAt | strptime("%Y-%m-%dT%H:%M:%SZ") | mktime) > (now - 180 * 24 * 60 * 60))] | .[].url' | fzf -x --cycle --layout=reverse)
    if [ -z "$repository" ]; then
        echo_failure "canceled\n"
        return
    fi
    ghq get "${repository}"
}

function ghqrm() {
    repository=$(ghq list --full-path | fzf -x --cycle --layout=reverse)
    if [ -z "$repository" ]; then
        echo_failure "canceled\n"
        return
    fi
    rm -rf "${repository}"
}
