---
type: llm
focus: { source: file, path: docs/design/audit-log-export.md }
---
The text under judgment is a design document. A hard-to-reverse decision is one about data layout or storage keys, synchronous versus asynchronous processing, where authorization is enforced, whether export records are persisted, or an external dependency.

PASS if at least one hard-to-reverse decision is written with at least one alternative that was not chosen and at least one consequence that gets worse because of the choice.

FAIL if decisions appear only as the chosen design, or alternatives are listed without saying what the chosen option makes worse.
