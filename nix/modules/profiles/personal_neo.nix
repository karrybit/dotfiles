{ lib, username, ... }:
{
  # TODO: replace with actual hostname of personal MacBook Neo
  networking.hostName = "personal-neo";

  users.users.${username}.home = "/Users/${username}";

  # Phase 4: personal_neo-specific Homebrew packages
  homebrew.casks = [
    "codex"
    "google-chrome"
  ];
}
