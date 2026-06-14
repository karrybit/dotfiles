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
      "zsh-autosuggestions" # Phase 6
      "zsh-completions"     # Phase 6
    ];

  };
}
