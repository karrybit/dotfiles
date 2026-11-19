mkdir -p "$XDG_CONFIG_HOME/aws"

export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config

# granted's `assume` must be sourced to set credentials in the current shell
# (https://docs.granted.dev/troubleshooting#manually-configuring-your-shell-profile).
# `.` searches only $path; zsh's `source` would run an `assume` in the current
# directory first.
alias assume=". assume"
