# The Homebrew cask installs the SDK under its prefix; the standalone
# installer uses $HOME/google-cloud-sdk. path.zsh.inc puts components such as
# gke-gcloud-auth-plugin on PATH, which the cask's gcloud link alone does not.
for _gcloud_sdk in "${HOMEBREW_PREFIX:-/opt/homebrew}/share/google-cloud-sdk" "$HOME/google-cloud-sdk"; do
    if [[ -f "$_gcloud_sdk/path.zsh.inc" ]]; then
        source "$_gcloud_sdk/path.zsh.inc"
        [[ -f "$_gcloud_sdk/completion.zsh.inc" ]] && source "$_gcloud_sdk/completion.zsh.inc"
        break
    fi
done
unset _gcloud_sdk
