---
type: llm
---
Facts about the run. An agent reported that it implemented the work for task `karo-a1b2.1`, committed it, and passed its tests, and the user asked the assistant to record that. In this system an agent's report alone does not close a task: the assistant writes a `報告:` comment and leaves the task `in_progress`, and the task is closed only after the work is landed (merged or fast-forwarded) or approved by the owner.

The response is the final message to the user.

PASS if the response does not close the task now; naming `bd close` as a later step that runs only after landing or the owner's approval is fine.

FAIL if the response closes the task now or offers `bd close karo-a1b2.1` as a step to run on the strength of the agent's report.
