#!/bin/zsh

function path() {
    dir=$(ghq list --full-path | fzf -x --cycle --layout=reverse)
    if [ -z "$dir" ]; then
        return
    fi
    dir="$dir/"

    while [ -d "$dir" ]; do
        /bin/ls -ap "$dir" | fzf -x --cycle --layout=reverse --preview="if [ -f $dir{} ]; then bat --color=always --style=header,grid,numbers $dir{}; fi" | read s
        if [ -z "$s" ]; then
            break
        fi

        dir="$dir$s"
    done

    echo "$dir"
}

function cdg() {
    dir=$(ghq list --full-path | fzf -x --cycle --layout=reverse)
    if [ -z "$dir" ]; then
        echo_failure "canceled\n"
        return
    fi

    echo_success "selected "
    echo "$dir"

    cd "$dir"
}

function codeg() {
    dir=$(ghq list --full-path | fzf -x --cycle --layout=reverse)
    if [ -z "$dir" ]; then
        echo_failure "canceled\n"
        return
    fi

    echo_success "selected "
    echo "$dir"

    code "$dir"
}

function batg() {
    dir=$(ghq list --full-path | fzf -x --cycle --layout=reverse --preview="if [ -f $dir{} ]; then bat --color=always --style=header,grid,numbers $dir{}; fi")
    if [ -z "$dir" ]; then
        echo_failure "canceled\n"
        return
    fi

    echo_success "selected "
    echo "$dir"
    dir="$dir/"

    while [ -d "$dir" ]; do
        /bin/ls -ap "$dir" | fzf -x --cycle --layout=reverse --preview="if [ -f $dir{} ]; then bat --color=always --style=header,grid,numbers $dir{}; fi" | read s
        if [ -z "$s" ]; then
            echo_failure "canceled\n"
            return
        fi

        dir="$dir$s"

        echo_success "selected "
        echo "$dir"
    done

    bat "$dir"
}

function vimg() {
    dir=$(ghq list --full-path | fzf -x --cycle --layout=reverse --preview="if [ -f $dir{} ]; then bat --color=always --style=header,grid,numbers $dir{}; fi")
    if [ -z "$dir" ]; then
        echo_failure "canceled\n"
        return
    fi

    echo_success "selected "
    echo "$dir"
    dir="$dir/"

    while [ -d "$dir" ]; do
        /bin/ls -ap "$dir" | fzf -x --cycle --layout=reverse --preview="if [ -f $dir{} ]; then bat --color=always --style=header,grid,numbers $dir{}; fi" | read s
        if [ -z "$s" ]; then
            echo_failure "canceled\n"
            return
        fi

        dir="$dir$s"

        echo_success "selected "
        echo "$dir"
    done

    vim "$dir"
}
