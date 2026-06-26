__lib_clipboard_copy() {
    case "${OSTYPE}" in
    darwin*) pbcopy ;;
    linux*)  xclip -selection clipboard ;;
    esac
}

__lib_clipboard_paste() {
    case "${OSTYPE}" in
    darwin*) pbpaste ;;
    linux*)  xclip -selection clipboard -o ;;
    esac
}
