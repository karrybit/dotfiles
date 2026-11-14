---
type: llm
focus: { source: file, path: docs/runbook-failover.md }
---
PASS if a warning to make sure the old primary is fenced still appears both at the promote step and at the step about retrying a failed promotion (two places, not merged into one).
FAIL if either location lost its fencing warning, or the two warnings were merged into one place.
