{ lib, username, ... }:
{
  determinateNix.enable = true;

  system.stateVersion = 5;

  nixpkgs.config.allowUnfree = true;

  users.users.${username}.home = "/Users/${username}";
}
