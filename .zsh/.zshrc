#!/bin/zsh

# theme
case $(uname -o) in
Darwin)
    zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'
    ;;
Linux)
    # Use powerline
    USE_POWERLINE="true"
    # Source manjaro-zsh-configuration
    if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
        source /usr/share/zsh/manjaro-zsh-config
    fi
    # Use manjaro zsh prompt
    if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
        source /usr/share/zsh/manjaro-zsh-prompt
    fi
    ;;
esac

source $ZDOTDIR/color.zsh
source $DOTFILES_PATH/util/func.zsh
source $ZDOTDIR/alias.zsh

# git
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit -u

for file in $(\find $DOTFILES_PATH/secret -maxdepth 1 -type f -name \*.zsh); do
    source $file
done

# direnv
eval "$(direnv hook zsh)"

# ruby
[[ -d ~/.rbenv ]] &&
    export PATH=${HOME}/.rbenv/bin:${PATH} &&
    eval "$(rbenv init -)"

# kube
[[ -d ~/.kube ]] &&
    source <(kubectl completion zsh)

# cargo
[[ -d ~/.local/share/cargo/env ]] &&
    source "$HOME/.local/share/cargo/env"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/karrybit/google-cloud-sdk/path.zsh.inc' ]; then . '/home/karrybit/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/karrybit/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/karrybit/google-cloud-sdk/completion.zsh.inc'; fi
if [[ -f "/opt/homebrew/bin/gcloud" ]]; then export GOOGLE_CLOUD_ACCESS_TOKEN=$(gcloud auth print-access-token); fi

# zsh
## autosuggestion
case $(uname -o) in
Darwin)
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ;;
*) ;;
esac

## history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt share_history

## prompt
# FIXME: broken
eval "$(starship init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
