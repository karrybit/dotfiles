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
      "antidote"            # zsh plugin manager — Phase 6
      "aqua"                # nixpkgs 未収録 — Homebrew のみ
      "chezmoi"             # bootstrapping: must exist before nix is set up
      "tmux"                # Phase 6
      "tpm"                 # Phase 6 — replace with programs.tmux.plugins
      "zsh-autosuggestions" # Phase 6
      "zsh-completions"     # Phase 6
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
