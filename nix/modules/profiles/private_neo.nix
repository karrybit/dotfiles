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
    herdr
    hyperfine
    jq
    lazygit
    neovim
    ripgrep
    shellcheck
    tree-sitter
    yq-go
    alloy6

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
    zsh-abbr

    # System tools (migrated from homebrew)
    autoconf
    cmake
    git
    gnused
    libpq
    openjdk
    python313
    tree
    wget
  ];

  home.file.".local/share/antidote".source = "${pkgs.antidote}/share/antidote";
}
