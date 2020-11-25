#!/bin/zsh

function ports() {
    case $# in
    0) lsof -i -P ;;
    1) lsof -i -P | grep "$1" ;;
    *) echo_failure 'argument number should be 1 or 0.\n' ;;
    esac
}
