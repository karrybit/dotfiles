{ lib, username, ... }:
{
  imports = [ ./homebrew.nix ];

  determinateNix.enable = true;

  system.stateVersion = 5;
  system.primaryUser = username;

  nixpkgs.config.allowUnfree = true;

  users.users.${username}.home = "/Users/${username}";
}
