{ lib, username, ... }:
{
  # TODO: replace with actual hostname of personal MacBook Neo
  networking.hostName = "personal-neo";

  users.users.${username}.home = "/Users/${username}";
}
