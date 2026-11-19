---
type: llm
focus: { source: file, path: source/meeting/2026-11-17-weekly-sync.md }
---
Facts about the fixture. The minutes of the 2026-11-17 weekly sync record two decisions: the backup retention period becomes 30 days, and the nightly batch starts at 1:00. A third topic, sending error notices to chat, was explicitly not decided and is to be discussed again. The action items are: 林 changes the retention setting by 11/20, and 青木 announces the batch start change by 11/21.

The text is the meeting note.

PASS if the note's `## 決定` section holds both decisions, its `## 宿題` section holds both action items with their owners and dates, and the chat notification topic is not recorded as a decision (it may appear as undecided or as next time's topic).

FAIL if a decision or an action item is missing or wrong, or if the chat notification topic is written as decided.
