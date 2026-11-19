# Repository Instructions

## Chezmoi Source Repository

- This repository is the chezmoi source tree for user dotfiles.
- Make durable changes in source paths such as `dot_config/...`, not in live
  target paths such as `~/.config/...`.
- Use `chezmoi source-path`, `chezmoi target-path`, and `chezmoi managed` when
  the source-to-target mapping is unclear.
- Preserve unrelated live differences and user-authored uncommitted changes.
- Editing source in a git worktree does not change what `chezmoi apply` reads:
  its source directory is `~/.local/share/chezmoi`, the main checkout, so an
  apply from a worktree deploys the main checkout's older content. Push as
  usual, then run `chezmoi update && chezmoi apply` from the main checkout once
  the change has merged.

## Source-Only Files

- Keep repository-only instructions and documentation listed in `.chezmoiignore`.
- Place directory-specific operating rules in the narrowest applicable
  `AGENTS.md`.
- Do not place directory-specific instructions in the repository root.

## Known Permission-Gated Operations

- For `chezmoi apply` in this environment, request the required approval on the
  first attempt instead of first producing the known
  `chezmoistate.boltdb: operation not permitted` failure.
- `pkl eval` fails under the command sandbox: JNA cannot write to the system temp
  directory and the command emits a Java stack trace instead of JSON, so a
  downstream `jq` reports a parse error rather than the real cause. Run it with
  `_JAVA_OPTIONS="-Djava.io.tmpdir=$TMPDIR -Djava.util.prefs.userRoot=$TMPDIR"`
  instead of disabling the sandbox.

## Verification

- Verify changes with `chezmoi apply --dry-run --verbose` and a fresh login
  shell. This repository deliberately has no test suite.
- When working in a git worktree, verify what would be applied with
  `chezmoi apply --dry-run --verbose -S <worktree>`, and run tests and
  evaluations that read deployed target files only after the change has merged
  and been applied.
- When extracting a copy with `chezmoi archive -S <worktree>`, select entries
  with target arguments and `--exclude`, since its `--include` excludes the
  named types instead (chezmoi v2.74.1).
- After changing chezmoi-managed paths or `.chezmoiignore`, verify that the
  intended files are managed or ignored as expected.
- Interpret unrelated existing live differences separately and report them
  without changing them.

## Documentation

- Review the relevant README when a change affects documented behavior,
  configuration layout, package management, or common operations.

## Agent Configuration, Skills, and Extensions

- Codex's `~/.codex/config.toml` is partially managed by
  `dot_codex/modify_private_config.toml`. Keep public preferences in that
  modifier, pass machine-local `[projects]` through without recording its
  values in source, and never copy the live file into the repository. Keep the
  `private_` attribute so the target remains mode `0600`.
- Repository instructions are `AGENTS.md` files: this one for the repository
  and `dot_config/nvim/AGENTS.md` for that directory. Claude Code reads them
  only while no `CLAUDE.md`, `.claude/CLAUDE.md`, or `CLAUDE.local.md` exists
  in the working directory or above it, so keep those names out of this tree.
- User-scope instructions stay `dot_config/claude/CLAUDE.md`, deployed to
  `~/.config/claude/CLAUDE.md`: Claude Code has no user-scope `AGENTS.md`.
  No instruction file imports another.
- Skills live in the `karrybit` plugin at `dot_config/claude/skills/karrybit/`,
  which deploys to `~/.config/claude/skills/karrybit/` and loads in place as
  `karrybit@skills-dir`, so each skill is called `karrybit:<skill>`; there is
  no intermediate canonical copy. The plugin's `exact_skills/` makes
  `chezmoi apply` remove a deployed skill whose source folder is gone.
- Place a karrybit skill in the folder of its responsibility,
  `exact_skills/exact_<category>/<skill>/`, and list each category in the
  manifest's `skills`, since Claude Code scans only `skills/<skill>/` by
  default; the folder does not change the name `karrybit:<skill>`. Give each
  category folder the `exact_` prefix, since chezmoi's `exact_` does not
  reach subfolders. `crit` sits directly in `exact_skills/`, where the
  default `skills/<skill>/` scan loads it.
- Skills and scripts that know the layout of the karo record repository,
  and the `herdr-agent` skill that starts and closes karo's Herdr agents,
  live in the `karo` plugin at `dot_config/claude/skills/karo/`, deployed and
  loaded the same way as `karo@skills-dir`. Its manifest sets
  `defaultEnabled: false`, so it loads only where a project's settings enable
  it; keep owner-specific values out of it and read them from the caller's
  arguments or from `$KARO_CONFIG_HOME/config.yaml`,
  `$KARO_HOME/rule/<skill>.md`, and `$KARO_HOME/project/repo/<name>.md`,
  each with a default for when the file is missing. It has no subagents: a
  karo skill hands work to a `karrybit` subagent and passes the karo rules in
  the request. Its hooks are in its
  `exact_hooks/hooks.json`, which Claude Code merges with the project's
  settings hooks, so keep them out of the project's settings: a hook in both
  runs twice.
- The karo plugin finds its folders through `KARO_HOME` (the record
  repository), `KARO_DATA_HOME`, `KARO_CONFIG_HOME`, and `KARO_STATE_HOME`;
  when one is unset, the scripts use `~/karo` and `karo` under
  `${XDG_DATA_HOME:-~/.local/share}`, `${XDG_CONFIG_HOME:-~/.config}`, and
  `${XDG_STATE_HOME:-~/.local/state}`. The karrybit plugin reads none of them
  and takes paths from its caller. The `land` skill's script reads no
  variable: it runs outside the sandbox on fixed folders. Nor does the
  `herdr-agent` skill's `agent-ctl`, whose ledger is the fixed file
  `~/.local/state/herdr-agent/ledger`.
- `run_onchange_04_prune-skills.sh.tmpl` removes skills deployed directly
  under `~/.config/claude/skills/` whose source entry is gone, which chezmoi
  does not do on its own. It only removes skills recorded in its own manifest,
  so skills installed by other routes survive.
- When changing the `description` of a document-writing skill
  (`karrybit:docs-information-design`, `karrybit:japanese-tech-writing`) or adding one, update
  the routing table and test cases in `docs/WRITING.md` in the same change.
- Claude Code subagents are in the `karrybit` plugin's `exact_agents/` and are
  called `karrybit:<agent>`; `dot_config/claude/agents/` holds the user-scope
  subagents called by a bare name (`eval-auditor`), deployed to
  `~/.config/claude/agents/`.
- Agent source summaries belong under `~/.local/share/agents/docs/`; only
  explicitly allowlisted summaries are chezmoi-managed.
- Agent-operated scripts belong under `~/.local/share/agents/scripts/`; only
  explicitly allowlisted script sets are chezmoi-managed.
- When a summary or script might belong to one skill only, read
  `dot_local/share/agents/docs/skill-design.md` before placing it.
