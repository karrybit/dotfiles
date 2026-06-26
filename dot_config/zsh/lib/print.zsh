__lib_echo_failure() {
    printf '\033[31m%b\033[0m' "$1" >&2
}

__lib_echo_warning() {
    printf '\033[33m%b\033[0m' "$1" >&2
}

__lib_echo_success() {
    printf '\033[32m%b\033[0m' "$1"
}
