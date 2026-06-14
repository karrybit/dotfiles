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

    # Batch3: common tools (gradle stays in aqua: nixpkgs 8.x vs aqua 9.x)
    jwt-cli
    qsv
    tfsec
    volta
  ];

  programs.home-manager.enable = true;
}
