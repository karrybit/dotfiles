{ lib, pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
}
