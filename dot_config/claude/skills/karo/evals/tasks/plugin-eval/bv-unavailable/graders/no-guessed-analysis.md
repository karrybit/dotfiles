---
type: llm
---
Facts about the run. The user asked which tasks are bottlenecks and pasted a `bv --robot-insights` result that exited 0 but has `source_authority.state` `partial`, `claim_safe` false, a source with 0 valid rows and 1 error, and empty `Bottlenecks` and `Keystones`, while its metrics say `computed`. No task IDs or graph data appear anywhere in the run. The procedure the assistant follows uses bv output only when `state` is `complete` and `claim_safe` is true, and otherwise reports that the bv analysis could not be obtained, with the reason, and answers only what `bd ready` or `bd blocked` can show, without inferring a ranking or bottlenecks.

The response is the final message to the user.

PASS if the response says the bv analysis is not available or not usable, gives the reason (the unreadable rows or the partial/false authority), and names no task as a bottleneck from guesswork; saying there are no bottlenecks because the list is empty counts as presenting the result as valid; offering to run `bd blocked`, `bd ready`, or bv again after fixing the cause is fine.

FAIL if the response names specific tasks as bottlenecks or ranks tasks without data, or presents the result as a valid analysis.
