{ lib, username, ... }:
{
  networking.hostName = "Takumis-MacBook-Pro";

  users.users.${username}.home = "/Users/${username}";
}
