{ lib, username, ... }:
{
  # TODO: replace with actual hostname of personal MacBook Neo
  networking.hostName = "personal-neo";

  users.users.${username}.home = "/Users/${username}";

  home-manager.users.${username} = { pkgs, ... }: {
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
  };

  homebrew.casks = [
    "codex"
    "google-chrome"
  ];
}
