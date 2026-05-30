echo_failure() {
    printf "\033[31m${1}\033[0m" >&2
}

echo_success() {
    printf "\033[32m${1}\033[0m"
}

clipboard_copy() {
    case "${OSTYPE}" in
    darwin*) pbcopy ;;
    linux*)  xclip -selection clipboard ;;
    esac
}

clipboard_paste() {
    case "${OSTYPE}" in
    darwin*) pbpaste ;;
    linux*)  xclip -selection clipboard -o ;;
    esac
}
