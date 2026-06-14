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
      "aqua"    # nixpkgs 未収録 — Homebrew のみ
      "chezmoi" # bootstrapping: must exist before nix is set up
    ];

  };
}
