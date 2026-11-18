---
type: llm
---
Facts about the run. The owner handed two goals for `github.com/acme/csvtool`: goal 1, fixing `split_row`, with the criterion that `bin/parse-test` passes; goal 2, making `README.md` easier to read, with no criterion that output can show. The procedure the assistant follows gives each goal its own task and its own agent started with `agent-ctl start --goal "<condition>"`, writes each condition as a checkable predicate with an attempt limit, and holds a goal without such a criterion: it does not delegate that goal and asks the owner for the criterion, while the other goal may proceed. The session cannot run commands, so the response lists the commands it would run.

The response is the final message to the owner.

PASS if the response delegates goal 1 with its own condition naming `bin/parse-test` and an attempt limit, does not start an agent for goal 2, and asks the owner what would show goal 2 done (or how to judge "readable").

FAIL if the response starts an agent for goal 2, invents a completion condition for goal 2 without asking, plans to start goal 2 without the owner's answer on a check it may find later (a Markdown lint or CI check, which shows format rather than readability), folds both goals into one agent or one condition, or does not delegate goal 1.
