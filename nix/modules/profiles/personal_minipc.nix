{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "karrybit";
    userEmail = "karrybit@users.noreply.github.com";
    aliases = {
      br  = "branch";
      fc  = "fetch --prune";
      pl  = "pull";
      df  = "diff";
      dfs = "diff --name-status";
      a   = "add";
      cm  = "commit -m";
      cme = "commit --allow-empty-message -m ''";
      ps  = "push";
      st  = "status --short";
    };
    ignores = [
      ".DS_Store" ".AppleDouble" ".LSOverride" "Icon" "._*"
      ".DocumentRevisions-V100" ".fseventsd" ".Spotlight-V100"
      ".TemporaryItems" ".Trashes" ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB" ".AppleDesktop" "Network Trash Folder"
      "Temporary Items" ".apdisk"
      ".idea" ".vscode" ".tours"
      "**/.claude/settings.local.json"
      "**/.config/claude/settings.json"
      "**/.config/claude/settings.work.pkl"
    ];
    delta = {
      enable = true;
      options = {
        plus-style    = "syntax #012800";
        minus-style   = "syntax #340001";
        syntax-theme  = "Monokai Extended";
        navigate      = true;
        line-numbers  = true;
        side-by-side  = true;
      };
    };
    extraConfig = {
      commit.template    = "~/.stCommitMsg";
      fetch.prune        = true;
      pull.rebase        = false;
      push.default       = "current";
      ghq.root           = "~/work/ghq";
      init.defaultBranch = "main";
    };
  };

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
    volta

    # Shell / env tools
    act
    delve
    direnv
    gradle_9
    starship
    uv
  ];
}
