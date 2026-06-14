{ lib, pkgs, ... }:
{
  home.stateVersion = "24.11";

  home.packages = [ ];

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
}
