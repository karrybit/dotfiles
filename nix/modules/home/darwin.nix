{ username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  nixpkgs.config.allowUnfree = true;
}
