# Declarative Homebrew managed by nix-darwin.
# cleanup = "none": existing unlisted packages are kept (safe during migration).
# Switch to "zap" in step 4.5 after all packages are listed here.
{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [
      "aquaproj/aqua"
      "microsoft/apm"
      "olets/tap"
    ];

    brews = [
      "antidote"           # zsh plugin manager (until phase 6)
      "aqua"               # CLI version manager (used at work; global package mgmt moved to nix)
      "autoconf"
      "chezmoi"            # bootstrapping: keep in Brew
      "cmake"
      "git"
      "gnu-sed"
      "libpq"
      "openjdk"
      "python@3.13"
      "tmux"               # until phase 6
      "tpm"                # until phase 6
      "tree"
      "wget"
      "zsh-autosuggestions" # until phase 6
      "zsh-completions"     # until phase 6
    ];

    casks = [
      "1password"
      "cleanshot"
      "ghostty"
      "google-japanese-ime"
      "intellij-idea"
      "itsycal"
      "karabiner-elements"
      "obsidian"
    ];
  };
}
