# Sandbox And Environment Gotchas

Checked: 2026-09-01

Revalidate when the command sandbox's filesystem restrictions change, when git's
tracking-setup defaults change, or when the shell startup files change which
variables they export.

Each section below explains one rule in the user `CLAUDE.md` under "Known
Permission-Gated Operations". The rule there is the operating constraint; this
file is the diagnosis to read when a command actually fails in one of these
ways.

## Pushing A New Branch Without `-u`

`push.default = current` is configured, so a plain `git push` succeeds without
upstream tracking. `-u`/`--set-upstream` writes the tracking branch to
`.git/config` regardless of `push.autoSetupRemote`, and that write fails with
`could not lock config file .git/config: Operation not permitted` when the
sandbox denies writes there. The push itself still succeeds, so the result is
avoidable error noise rather than a failed push.

## Merged Branches Never Show `[gone]`

A branch pushed without `-u` has no upstream ref configured, so its `[gone]`
marker in `git branch -v` never appears even after the remote branch is deleted:
`%(upstream:track)` has no effect without tracking information. Cleanup that
keys off `[gone]`, such as `clean_gone`, therefore cannot detect these branches,
which is why merged local branches are inventoried with
`git branch --merged <base-branch>` instead.

## Deleting A Tracked Branch Leaves `.git/config` Debris

`git branch -d <branch>` removes the ref itself even when the sandbox denies
writes to `.git/config`, but a branch with tracking config (`remote`, `merge`,
or keys other tools wrote — VS Code's `vscode-merge-base`, `gh`'s
`github-pr-base-branch`) also needs its `[branch "<name>"]` section deleted
from `.git/config`, and that write hits the same `could not lock config file
.git/config: Operation not permitted` as the push case. Because `[gone]` only
appears on a branch with tracking config, every branch `clean_gone` actually
deletes is a candidate for this: the branch disappears from `git branch -a`
but its `[branch "..."]` section survives in `.git/config`, accumulating
across repeated cleanups. A successful `clean_gone` run does not guarantee
`.git/config` came out clean — check it directly and remove stale sections by
hand.

## `clean_gone` Cannot Delete The Branch You Are On

`git branch -D <branch>` refuses to delete the currently checked-out branch.
`clean_gone`'s cleanup loop does not check for this before calling
`git branch -D`, and the loop has no `set -e`, so that refusal prints to
stderr and the loop continues past it instead of stopping the run — the
branch survives, unreported as a failure. Confirmed by reading the plugin
source
(`~/.config/claude/plugins/marketplaces/claude-plugins-official/plugins/commit-commands/commands/clean_gone.md`):
the command only ever runs `git branch -v`, `git worktree list`, and the
delete loop. It contains no `git switch`/`git checkout` step, so nothing in
`clean_gone` itself ever moves you off a branch before trying to delete it.

This is not a rare edge case: the branch you are on right after a PR merges
is exactly the branch most likely to have gone `[gone]`, so running
`clean_gone` from the branch you just finished is the common case that hits
this. Switch to the repository's default branch and pull first (the
`sync-default-branch` skill) so the branch you are on when the delete loop
runs is never one of its own targets.

## Branching From A Remote Ref

`git switch -c <new> <remote-ref>` and `git checkout -b <new> <remote-ref>` hit
the same `.git/config` write restriction, because branching from a
remote-tracking ref implicitly sets up upstream tracking too
(`branch.autoSetupMerge`).

Unlike a plain push, this failure is not cosmetic: it can leave the repository
half-switched, with HEAD and the branch ref still on the old branch while the
index and working tree already hold the new ref's content.
`git branch --no-track <new> <remote-ref> && git checkout <new>` reaches the same
end state without triggering the tracking-setup write.

## `.env*` Files Reported As Deleted

`.env.example` and similar template files fall under the sandbox's filesystem
read-deny for `.env*` paths. When that applies, `git status` and `git diff`
report the file as deleted even though it still exists on disk and in git
history. This is a false positive produced by the read block, not an actual
deletion, so restoring the file, staging the deletion, or committing in response
all corrupt the tree further. `git show HEAD:<path>` reads the committed content
and confirms the real state.

## Environment Variables That Do Not Match The Dotfiles

A running Claude Code session's Bash tool spawns a fresh shell per call, but that
shell inherits environment variables frozen from whenever its actual long-lived
ancestor process started, not from re-sourcing the current dotfiles. A tmux
server is the usual ancestor: it captures the environment at server-start and
hands that copy to every pane and window for the server's whole lifetime.

So when a `zshenv.d` file starts exporting a new variable, an already-running
ancestor keeps the old — often unset — value until the ancestor itself restarts.
Restarting the terminal window or the Claude Code client changes nothing if both
still attach to the same tmux server underneath.

To tell this apart from a genuine dotfiles or allowlist defect, compare
`ps -o lstart -p $PPID` against the dotfile's last-applied mtime. When the
variable's export was added after the current session started, the fix is
restarting the long-lived ancestor — `tmux kill-server`, or launching from a
shell outside tmux — not editing the sandbox allowlist.

`~/.config/zsh/dot_zshenv`'s double-sourcing guard (`_ZSHENV_SOURCED`) is
deliberately unexported, so a brand-new process tree picks up current exports
without any restart. Only process trees that predate that guard need the
one-time restart.
