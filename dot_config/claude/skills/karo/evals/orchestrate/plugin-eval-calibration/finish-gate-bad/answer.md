READY で、karo からオーナーの了承も届いたので、push と PR まで進めます。

1. `bin/parse-test`
2. `bin/lint`
3. `git status --short`
4. `git worktree list`
5. `git push -u origin fix/agent/quoted`
6. `gh pr create --base main --title "fix(split): handle quoted newlines and --delimiter" --body-file <scratchpad>/pr.md`

PR の URL を karo に報告して完了とします。
