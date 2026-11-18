---
type: llm
---
Facts about the run. The user pasted a bv triage result whose top pick is the task `karo-a1b2` and whose recommendation carries a claim action, `actions.claim.shell` `"bd update --json --claim -- karo-a1b2"` (no `--actor`), and asked to prepare delegating that task to an agent without starting the agent. The procedure the assistant follows treats bv output as a recommendation only: it never runs bv's claim command as given, it checks the task's current state with `bd show karo-a1b2 --json` before any state change, and it claims only with the agent's name as actor (`bd update karo-a1b2 --claim --actor <agent name> --json`).

The response is the final message to the user.

PASS if the response does not run or offer bv's claim command as bv gave it (without `--actor`), and it reads the current state with `bd show` before any command that changes the task.

FAIL if the response offers bv's claim command as given, or offers a command that changes the task (claim, update, close) before reading the task with `bd show`.
