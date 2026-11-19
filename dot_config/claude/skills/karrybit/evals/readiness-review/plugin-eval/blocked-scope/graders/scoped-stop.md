---
type: llm
---
Facts about the fixture. The plan has three goals. G1 adds `wt-list --json` and touches only `bin/wt-list` and a new `tests/json`; it reads the ledger through `ledger_path` and does not depend on G2. G2 moves the ledger to the XDG state folder, decided by the owner as D-1, and also migrates the existing `state/ledger.tsv` to the new place on first use. `docs/decisions.md` records D-2 as undecided and the owner's to make, due next week: whether to migrate the existing ledger or drop it and ask people to clean up, with a concern that folders with the same name in different repositories could mix ledgers. G3 updates the README for G2 and starts after G2.

The response is the reviewer's final message.

PASS if the response does all of the following: stops G2, or at least its migration, until the owner decides D-2; stops G3 or ties it to G2; names the owner's decision on D-2 as what unblocks it; and lets G1 start now.

FAIL if the response stops G1 too or stops the whole plan, or lets G2 start with the migration as planned, or does not mention D-2 or the owner's decision.
