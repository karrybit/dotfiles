{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLI tools
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

    # Dev tools
    actionlint
    awscli2
    gh
    go
    go-task
    nickel
    pkl
    terraform
    tflint

    # CLI tools (misc)
    jwt-cli
    qsv
    tfsec
    nodejs_22

    # Shell / env tools
    act
    delve
    gradle_9
    starship
    uv
  ];

  home.file.".local/share/antidote/antidote.zsh".source =
    "${pkgs.antidote}/share/antidote/antidote.zsh";
}
