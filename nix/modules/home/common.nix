{ lib, pkgs, ... }:
{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Batch1: modern CLI tools (migrated from aqua)
    bat
    curlie
    delta
    deno
    dust
    eza
    fd
    fzf
    ghq
    gping
    hyperfine
    jq
    lazygit
    neovim
    ripgrep
    shellcheck
    tree-sitter
    yq-go
  ];

  programs.home-manager.enable = true;
}
