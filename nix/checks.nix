# Smoke-test checks for `nix flake check`.
# Each derivation forces evaluation of a key attribute; wrong types or missing
# attrs fail at evaluation time before the derivation even builds.
{ nixpkgs, self, homeConfigs }:
let
  inherit (nixpkgs) lib;

  # Force evaluation of `value` (must coerce to string) and write it to $out.
  mkCheck = pkgs: name: value:
    pkgs.runCommand "check-${name}" { } ''
      printf '%s\n' ${pkgs.lib.escapeShellArg (toString value)} > $out
    '';

  # Tools that `dot_config/claude/CLAUDE.md` ("Command-Line Tool Preferences")
  # tells agents to prefer over their POSIX equivalents. These are a contract,
  # not the usual profile coincidence: an agent runs on every machine, so a rule
  # naming a tool is only satisfiable if every profile declares it. Packages stay
  # declared per profile (profile-per-package principle) — only this assertion is
  # shared. Keys are the binary the rule names, values the nixpkgs attribute.
  agentRequiredTools = {
    rg = "ripgrep";
    fd = "fd";
    jq = "jq";
    yq = "yq-go";
    qsv = "qsv";
  };

  # Every agent-required tool a profile fails to declare, as fix-it lines.
  # Reading a package's name is pure evaluation, so profiles for other platforms
  # are covered too — a Linux-only gap surfaces from a Mac. The profile list comes
  # from `homeConfigs`, so a new host is covered without touching this file.
  agentToolGaps =
    let
      gapsIn = profile:
        let
          declared = map lib.getName homeConfigs.${profile}.config.home.packages;
        in
        lib.mapAttrsToList
          (bin: attr: "  ${profile}: `${bin}` — add `${attr}` to nix/modules/profiles/${profile}.nix")
          (lib.filterAttrs (_bin: attr: !lib.elem attr declared) agentRequiredTools);
    in
    lib.concatMap gapsIn (lib.attrNames homeConfigs);

  # Registered for both systems so whichever machine runs `nix flake check` gets
  # it; each copy asserts every profile, so no cross-platform build is needed.
  mkAgentToolsCheck = pkgs:
    if agentToolGaps == [ ]
    then pkgs.runCommand "agent-required-tools" { } "touch $out"
    else
      throw ''
        agent-required-tools: these profiles do not declare tools that
        dot_config/claude/CLAUDE.md tells agents to prefer:
        ${lib.concatStringsSep "\n" agentToolGaps}
        Add the package to that profile, or drop the tool from the
        Command-Line Tool Preferences rule.
      '';

  darwinPkgs = nixpkgs.legacyPackages."aarch64-darwin";
  linuxPkgs  = nixpkgs.legacyPackages."x86_64-linux";
in
{
  "aarch64-darwin" = {
    statix = darwinPkgs.runCommand "statix" {
      nativeBuildInputs = [ darwinPkgs.statix ];
    } ''
      statix check ${self}
      touch $out
    '';

    deadnix = darwinPkgs.runCommand "deadnix" {
      nativeBuildInputs = [ darwinPkgs.deadnix ];
    } ''
      deadnix --fail ${self}
      touch $out
    '';

    work-state-version =
      mkCheck darwinPkgs "work-state-version"
        homeConfigs.work.config.home.stateVersion;

    work-username =
      mkCheck darwinPkgs "work-username"
        homeConfigs.work.config.home.username;

    personal-neo-state-version =
      mkCheck darwinPkgs "personal-neo-state-version"
        homeConfigs.private_neo.config.home.stateVersion;

    personal-neo-username =
      mkCheck darwinPkgs "personal-neo-username"
        homeConfigs.private_neo.config.home.username;

    agent-required-tools = mkAgentToolsCheck darwinPkgs;
  };

  "x86_64-linux" = {
    personal-minipc-state-version =
      mkCheck linuxPkgs "personal-minipc-state-version"
        homeConfigs.private_minipc.config.home.stateVersion;

    personal-minipc-username =
      mkCheck linuxPkgs "personal-minipc-username"
        homeConfigs.private_minipc.config.home.username;

    agent-required-tools = mkAgentToolsCheck linuxPkgs;
  };
}
