{ lib, pkgs, ... }:
{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Batch1: modern CLI tools
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

    # Batch2: common dev tools
    actionlint
    awscli2
    gh
    go
    go-task
    nickel
    pkl
    terraform
    tflint
  ];

  programs.home-manager.enable = true;
}
