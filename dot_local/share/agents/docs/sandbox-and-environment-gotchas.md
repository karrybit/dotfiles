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

## `[gone]` And `--merged` Each Miss A Class Of Merged Branch

A branch pushed without `-u` has no upstream ref configured, so its `[gone]`
marker in `git branch -v` never appears even after the remote branch is deleted:
`%(upstream:track)` has no effect without tracking information. Cleanup that
keys off `[gone]` therefore finds nothing here.

`git branch --merged <base-branch>` covers what `[gone]` misses, but only
branches whose tip is an ancestor of the base branch. A squash-merged branch is
not an ancestor — its own commits never entered the base branch — so it appears
in neither list, and `git branch -d` refuses it with `error: the branch
'<name>' is not fully merged`.

`git cherry <base-branch> <branch>` does not close the gap. It compares
patch-ids, so it matches a squash of a single commit but reports every commit of
a multi-commit squash as unmerged.

The authoritative signal is the forge:

    gh pr list --head <branch> --state all --json number,state,mergedAt

It answers after the remote branch is deleted, and returns an empty list rather
than an error for a branch it does not know. A `MERGED` result is the evidence
that justifies `git branch -D`.

## Deleting A Branch Another Tool Configured Leaves `.git/config` Debris

`git branch -d <branch>` removes the ref itself even when the sandbox denies
writes to `.git/config`, but a branch carrying a `[branch "<name>"]` section
also needs that section deleted, and that write hits the same `could not lock
config file .git/config: Operation not permitted` as the push case.

Nothing done under the sandbox creates such a section: writing tracking config
is the operation the denial blocks, so branches created here are untracked and
delete cleanly. The sections that do exist were written by tools running outside
the sandbox — VS Code's `vscode-merge-base`, `gh`'s `github-pr-base-branch`, or
a `-u` push from an ordinary shell. Deleting one of those branches leaves its
section behind; report the leftover, because removing it needs the write that is
denied.

## Why Cleanup Does Not Use `clean_gone`

Three properties of the command, confirmed by reading the plugin source
(`~/.config/claude/plugins/marketplaces/claude-plugins-official/plugins/commit-commands/commands/clean_gone.md`),
which only ever runs `git branch -v`, `git worktree list`, and a delete loop:

- It selects targets by `[gone]`, which never appears on the branches this
  environment produces.
- It deletes with `git branch -D`, discarding unmerged work without asking.
- It contains no `git switch`/`git checkout` step, so it can be run from a
  branch that is itself a target. `git branch -D` refuses to delete the
  currently checked-out branch, and the loop has no `set -e`, so that refusal
  prints to stderr and the loop continues — the branch survives, unreported as a
  failure. The branch you are on right after a PR merges is exactly the one most
  likely to be a target, so this is the common case rather than an edge.

The `sync-default-branch` skill covers the same intent without those
properties: it moves to the default branch before deleting anything, selects on
positive evidence, and reserves `-D` for a branch a `MERGED` pull request
accounts for.

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
ancestor process started, not from re-sourcing the current dotfiles. The
multiplexer server is the usual ancestor: it captures the environment at
server-start and hands that copy to every pane for the server's whole lifetime.

So when a `zshenv.d` file starts exporting a new variable, an already-running
ancestor keeps the old — often unset — value until the ancestor itself restarts.
Restarting the terminal window or the Claude Code client changes nothing if both
reattach to the same multiplexer server underneath.

To tell this apart from a genuine dotfiles or allowlist defect, compare
`ps -o lstart -p $PPID` against the dotfile's last-applied mtime. When the
variable's export was added after the current session started, the fix is
restarting that ancestor — `herdr server stop`, or launching from a shell outside
the multiplexer — not editing the sandbox allowlist.

`~/.config/zsh/dot_zshenv`'s double-sourcing guard (`_ZSHENV_SOURCED`) is
deliberately unexported, so a brand-new process tree picks up current exports
without any restart. Only process trees that predate that guard need the
one-time restart.
