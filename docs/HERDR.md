# herdr Usage

> The package is declared in `home.packages` in `nix/modules/profiles/<profile>.nix`.
> Configuration is `~/.config/herdr/config.toml`, chezmoi-managed from
> `dot_config/herdr/config.toml`. Everything else under `~/.config/herdr/`
> (`session.json`, `sessions/`, `plugins/`, logs, sockets) is runtime state.

herdr is a terminal workspace manager: a background server owns the panes, and
the terminal you launch is a client attached to it. Closing the terminal leaves
every pane process running.

Run `herdr` when a session needs it — agent work, long-running processes, a
project you want to keep open — and use a plain shell otherwise.

## Prefix Key

The prefix is **`ctrl+t`**, matching the tmux prefix here. herdr's own default,
`ctrl+b`, therefore stays free.

`<prefix>` = `ctrl+t` throughout this document. `ctrl+b` stays available inside
panes and keeps its page-up meaning in copy mode.

Press `<prefix> ?` for the live list of active bindings, and `/` inside that
panel to filter it.

---

## Model

| Concept | Meaning |
|---|---|
| Workspace | Project container — one per repo, task, or investigation |
| Tab | A layout inside a workspace (`agents`, `logs`, `review`, …) |
| Pane | A real terminal |
| Agent | A coding agent herdr recognizes inside a pane |
| Session | A separate server namespace; workspaces come first, sessions only when panes and sockets must be fully separate |

---

## Server and Persistence

| Action | Command |
|--------|---------|
| Start or attach | `herdr` |
| Detach, leave everything running | `<prefix> q` |
| Reload `config.toml` | `herdr server reload-config` / `<prefix> shift+r` |
| Stop the server and its panes | `herdr server stop` |
| List / attach named sessions | `herdr session list` / `herdr session attach <name>` |
| Attach over SSH | `herdr --remote <host>` |

`herdr` spawns the server when none is running, then attaches. The launch
directory seeds the startup workspace only when the restored session has no
workspaces of its own; otherwise it is ignored and `herdr` just attaches. Further
workspaces come from `<prefix> shift+n`, which inherits the focused pane's
current directory, or from `herdr workspace create --cwd <path> --focus`.

Leave a session with `<prefix> q`, and end it with `herdr server stop`. `exit`
in a pane shell is not the way out: it closes that pane, and closing the last
one empties the session, which makes herdr open a replacement workspace. A
replacement has no pane to inherit from, so `new_cwd = "follow"` falls back to
`$HOME`, and an unexpected `$HOME` workspace means a session was emptied that
way. Create the project workspace before closing the one you no longer want,
since closing the only workspace triggers the same replacement.

Detach and reattach keeps the original processes. A server restart restores
workspaces, tabs, panes, cwd, and layout, but the old processes are gone; panes
come back as fresh shells. Supported agents resume their own conversation
instead, through their integration (`[session] resume_agents_on_restore`,
enabled by default).

---

## Workspaces

| Action | Key |
|--------|-----|
| New workspace | `<prefix> shift+n` |
| Workspace picker | `<prefix> w` |
| Session navigator (search the session) | `<prefix> g` |
| Rename workspace | `<prefix> shift+w` |
| Close workspace | `<prefix> shift+d` |
| Toggle sidebar | `<prefix> b` |
| New Git worktree workspace | `<prefix> shift+g` |

One workspace per repo, task, or investigation. Workspaces persist in the saved
session, so they are created once and then switched between — the sidebar rolls
agent state up per workspace and shows its branch and ahead/behind counts, which
only means something when the workspace is rooted at a repository. Splitting
panes and `cd`-ing around inside a single workspace gives that up: every agent
lands under one row.

---

## Tabs

| Action | Key |
|--------|-----|
| New tab | `<prefix> c` |
| Next / previous tab | `<prefix> n` / `<prefix> p` |
| Jump to tab 1–9 | `<prefix> <number>` |
| Rename tab | `<prefix> shift+t` |
| Close tab | `<prefix> shift+x` |

---

## Panes

### Splitting

| Action | Key |
|--------|-----|
| Split left/right | `<prefix> v` / `<prefix> \|` |
| Split top/bottom | `<prefix> -` / `<prefix> _` |

### Navigation (vim keys)

| Action | Key |
|--------|-----|
| Focus left / lower / upper / right pane | `<prefix> h` / `j` / `k` / `l` |
| Cycle panes | `<prefix> Tab` / `<prefix> shift+Tab` |
| Swap panes | `<prefix> shift+h` / `shift+j` / `shift+k` / `shift+l` |

### Other

| Action | Key |
|--------|-----|
| Resize mode | `<prefix> r` |
| Zoom / unzoom pane | `<prefix> z` |
| Close pane | `<prefix> x` |
| Rename pane | `<prefix> shift+p` |
| Open scrollback in `$EDITOR` | `<prefix> e` |

Mouse works everywhere too: click to focus, drag borders to resize,
right-click for menus, drag-select to copy.

---

## Copy Mode (vi keys)

| Action | Key |
|--------|-----|
| Enter copy mode | `<prefix> [` |
| Move cursor | `h` / `j` / `k` / `l` |
| Word motions | `w` / `b` / `e`, `W` / `B` / `E` |
| Paragraph motions | `{` / `}` |
| Page / half page | `ctrl+b` / `ctrl+f`, `ctrl+u` / `ctrl+d` |
| Search forward / backward | `/` / `?`, then `n` / `N` |
| Start selection | `v` or `Space` |
| Copy | `y` or `Enter` |
| Exit copy mode | `q` or `Esc` |

Search is case-insensitive unless the query contains an uppercase letter. The
pane keeps producing output while copy mode is open.

---

## Agent States

The sidebar marks every pane across every workspace, so the one that needs an
answer is visible without hunting for it.

| State | Meaning |
|---|---|
| `blocked` | Needs input, approval, or a decision |
| `working` | Actively running |
| `done` | Finished and not looked at yet |
| `idle` | Finished or waiting, already seen |
| `unknown` | herdr cannot classify it confidently |

`done` and `idle` are the same underlying state; the difference is whether the
result has been seen. Focusing the tab, or `pane focus` / `agent focus`, marks
it seen — a CLI read does not. State rolls up from pane to tab to workspace,
which is what makes the sidebar answer "which project needs me".

Background state changes raise an in-app toast (`[ui.toast] delivery`) and a
sound (`[ui.sound]`).

Claude Code's state comes from screen detection: herdr matches TOML manifests
against the pane's live bottom-buffer snapshot. `blocked` is deliberately
strict, so an approval screen herdr does not recognize shows as `idle` rather
than `blocked`. `herdr agent explain <target>` prints the manifest source, the
matched rule, and the evidence behind a classification, and a local override
can go in `~/.config/herdr/agent-detection/claude.toml`.

Useful CLI while agents run:

```sh
herdr agent list                          # known agents and their state
herdr pane read <pane-id> --lines 50      # what herdr can see in a pane
herdr agent explain <target>              # why a pane is in that state
herdr integration status                  # installed agent integrations
```

---

## Driving herdr From a Script or an Agent

The CLI is a first-class surface: most commands return JSON, and IDs come from
the response rather than from guesswork. Layout, pane, and agent are separate
primitives — `agent start` needs an existing shell pane at its prompt and never
creates layout.

`herdr --skill` prints the command guide that matches the installed binary,
including the split/start/prompt/read recipes and the state semantics. Read it
from there rather than from a copy, since it moves with the release.

Claude Code draws on the terminal's alternate screen, so transcript history is
not in herdr's scrollback. herdr pages it back through the agent's own scroll
interface, but only for an idle agent: `agent read --lines N` returns
`agent_not_idle` while the agent is working or blocked.

---

## Operational Notes

Panes inherit the **server's** macOS launch context. A server first spawned
from a background context — an SSH session, a launch agent, a tool-driven
shell — leaves every pane without interactive Keychain access. Check with
`launchctl managername` inside a pane; if it prints `Background`, run
`herdr server stop` and start `herdr` again from a normal GUI terminal.

Never let a shell startup file enter tmux inside a pane: herdr would see `tmux`
as the pane process and lose the agent behind it.

Direct attach (`herdr agent attach <target>`, `herdr terminal attach <id>`)
streams one terminal into the current window instead of the full UI. Its detach
key is `ctrl+b q` regardless of `keys.prefix`, and `ctrl+b ctrl+b` sends a
literal `ctrl+b`.

chezmoi owns `config.toml`, and herdr writes to it as well: choices made in its
Settings surface (theme, status indicators, sound, toast delivery, agent panel
ordering) and the `onboarding` flag are upserted into the file, leaving comments
and unrelated keys intact. Editing the chezmoi source stays the way to change a
setting durably. When a setting is changed in the app instead, `chezmoi apply`
refuses the file because the target moved — that refusal is the signal — and the
change is adopted with:

```sh
chezmoi re-add ~/.config/herdr/config.toml
```

Then commit the source. Discarding the in-app change instead is
`chezmoi apply --force`.

---

## Claude Code Integration

`herdr integration install claude` writes
`~/.config/claude/hooks/herdr-agent-state.sh` and expects a matching
`SessionStart` entry in `~/.config/claude/settings.json`. That settings file is
generated from `dot_config/claude/settings.base.pkl`, which declares the entry,
so it survives regeneration.

herdr recognizes its own entry by exact command string, so the declared string
has to track what herdr writes. `generate_claude_settings` installs the
integration over the file it just generated: that is a no-op while the two
agree, and when a herdr release changes the canonical command, herdr rewrites
the entry and the script prints the new string to update `settings.base.pkl`
with. Leaving it stale makes every regeneration drop herdr's entry again.

`herdr integration status` cannot stand in for that check — it reports the
version of the installed hook script and says `current` even when the settings
entry is missing.

The hook reports only the session id, which is what lets a Claude pane resume
its conversation after a server restart. Working/blocked detection does not
depend on it.

---

## Differences From tmux

`docs/TMUX.md` documents the tmux setup. Where the two disagree:

| tmux | herdr |
|---|---|
| `exit` in the last pane ends the session | Reopens an empty workspace; leave with `<prefix> q` or `herdr server stop` |
| `<prefix> r` reloads the config | `<prefix> r` enters resize mode; reload is `<prefix> shift+r` |
| `<prefix> H/J/K/L` resizes panes | Swaps panes; resize through `<prefix> r` or explicit `keys.resize_pane_*` bindings |
| `<prefix> s` lists sessions | Opens settings; per-project separation is a workspace, not a session |
| `<prefix> Tab` opens a file-tree sidebar | Cycles panes. The sidebar is the agent/workspace dashboard; there is no built-in file tree — bind a popup command (`lazygit`, a file viewer) with `[[keys.command]]` if one is needed |
| `o` / `ctrl+o` / `S` on a copy-mode selection | ctrl+click a link in the pane (OSC 8 hyperlinks and visible URLs) |
| Windows and panes are numbered from 1 | Tabs jump with `<prefix> 1..9`; panes are addressed by focus keys and the goto picker |

---

## Configuration

`dot_config/herdr/config.toml` holds the deviations from herdr's defaults; the
file itself is the list.

```sh
herdr config check         # validate config.toml (unknown keys, bad bindings, themes)
herdr --default-config     # full commented default config
herdr --help               # resolved config path for this machine
```

The complete key reference is at <https://herdr.dev/docs/config-reference/>.
