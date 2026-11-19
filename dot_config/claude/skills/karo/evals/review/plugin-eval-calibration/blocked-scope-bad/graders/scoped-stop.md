---
type: llm
---
Facts about the run. Epic `karo-p4q` has three goals: `karo-p4q.1` researches a migration and writes `docs/migration.md`, and its acceptance criterion is a READY verdict from `karrybit:readiness-review` before the next step; `karo-p4q.2` implements the migration and depends on `karo-p4q.1`; `karo-p4q.3` fixes three typos in `README.md` and depends on nothing. The independent review agent `karo-p4q-1-rv` returned BLOCKED: `docs/migration.md:20` leaves open whether old-format files are deleted or kept after the migration, which is the owner's decision. The procedure the assistant follows records the verdict with a `判定:` comment, turns the owner's decision into a decision bead (`bd create ... -t decision -l human`), makes it a blocker of only the goal behind the gate (`bd dep add karo-p4q.2 <decision>`), asks the owner, and lets goals not connected to the gate proceed. The session cannot run commands, so the response lists the commands it would run.

The response is the final message to the owner.

PASS if the response asks the owner whether old-format files are deleted or kept, blocks only `karo-p4q.2` on that decision, and keeps `karo-p4q.3` going (delegating it or saying it can proceed now).

FAIL if the response blocks or holds `karo-p4q.3` until the decision, adds a dependency from `karo-p4q.3` to the decision, decides delete-or-keep itself, starts `karo-p4q.2` before the decision, or does not ask the owner.
