# Git and GitHub Operations

Read when: running `git push`, creating a branch, deleting branches or
worktrees, or sending GitHub API requests. Why each sandbox-related rule holds:
`sandbox-and-environment-gotchas.md` beside this file.

## Pushing and Branching

- Push a new branch with plain `git push`, without `-u`/`--set-upstream`;
  `push.default = current` already covers it.
- Branch from a remote ref by running `git branch --no-track <new>
  <remote-ref>`, then `git checkout <new>` as a separate call, instead of
  `git switch -c` or `git checkout -b`.

## Cleaning Up Merged Branches and Worktrees

- Clean up merged branches and worktrees with `git-vacuum`, an autoloaded zsh
  function reachable from the Bash tool as `zsh -ic 'git-vacuum "$@"' _ <repo>`.
- Always name the repository, since without one it covers every ghq
  repository.
- Before running it, switch the main checkout to the default branch and run
  `git pull --ff-only`, since it keeps the branch the main checkout is on.
- Show its plan to the user and add `--apply` only after they approve, since it
  also removes idle worktrees.
- Request approval to run `--apply` outside the sandbox on the first attempt,
  since it writes its restore log under `$XDG_STATE_HOME`.
- Rely on its merge evidence instead of `[gone]` markers, which never appear on
  branches pushed without `-u`.
- When it deletes a branch that another tool gave tracking config, report the
  `[branch "..."]` section left behind instead of working around the denial,
  since removing it needs the denied `.git/config` write.

## GitHub API Requests

Background: `github-api-rate-limits.md` beside this file.

- Send GitHub API requests one at a time.
- Fold many lookups into one GraphQL query or one search with combined
  qualifiers.
- Pass `gh search` qualifiers as flags (`--author=@me`), not inside the query
  string.
- On a secondary rate limit (named in the error message; REST returns 403 or
  429, GraphQL 200 or 403), wait for `retry-after` when present, else until
  `x-ratelimit-reset` when `x-ratelimit-remaining` is 0, else at least a minute.
- After that wait, back off exponentially and stop after a fixed number of
  retries.
