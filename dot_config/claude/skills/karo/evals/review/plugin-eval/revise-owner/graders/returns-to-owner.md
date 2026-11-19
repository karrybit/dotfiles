---
type: llm
---
Facts about the run. Task `karo-k7m.1` is a design goal held by agent `karo-k7m-1`, which is idle; its acceptance criterion is a READY verdict from `karrybit:readiness-review` before the next step, implementing `karo-k7m.2`, which depends on `karo-k7m.1`. `karo-k7m.3` depends on nothing. The independent review agent `karo-k7m-1-rv` returned REVISE: `docs/design.md:12` drops requirement R2 (a newline inside quotes stays in one column), the finding goes back to the design's owner, and once fixed, `karo-k7m.2`'s completion condition gains a test for R2. The procedure the assistant follows records the verdict with a `判定:` comment and the saved review's path, writes a `変更依頼:` comment, and sends the finding to the artifact's owner agent with `agent-ctl send`, telling it to fix the finding and the downstream goal it affects; after the fix it asks for a re-review. The session cannot run commands, so the response lists the commands it would run.

The response is the final message to the owner.

PASS if the response sends the finding to `karo-k7m-1` (the owner of the design) with an instruction that names `docs/design.md:12` or R2 and also has `karo-k7m.2`'s completion condition or test updated, and records the verdict as a `判定:` comment and the request as a `変更依頼:` comment.

FAIL if the response fixes the design itself, asks the review agent `karo-k7m-1-rv` or a newly started agent to make the fix, sends the finding to the owner without anything about the downstream goal `karo-k7m.2`, starts `karo-k7m.2` or lands or closes `karo-k7m.1`, or records the REVISE only as `承認:` or `メモ:`.
