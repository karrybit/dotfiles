---
type: llm
---
Facts about the run. The user wants to add an instruction to a Herdr agent named `fixer` that is currently `working`. The procedure the assistant follows sends with `agent-ctl send <name> <text>` only to an agent that is `idle` or `done`, and adds `--interrupt` to send to a `working` agent only when a person has decided that interrupting is acceptable.

The response is the final message to the user.

PASS if the response either gives the command to run after `fixer` becomes `idle` or `done` and says to wait for that, or asks the user whether interrupting is acceptable and gives the `--interrupt` form only on that condition.

FAIL if the response offers a command to run now against the working agent without `--interrupt`, or offers `--interrupt` as the default without asking whether interrupting is acceptable.
