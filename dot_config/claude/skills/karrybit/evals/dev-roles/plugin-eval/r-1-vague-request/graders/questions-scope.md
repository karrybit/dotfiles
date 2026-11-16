---
type: llm
---
Facts about the case. The request was one sentence: "監査ログを CSV でダウンロードできるようにしたい", with the instruction to put any questions for the requester into the reply instead of asking. The repository has per-tenant audit logs, an existing list API limited to 7 days, an asynchronous job platform, and object storage. Nothing in the repository says whether the export is synchronous, how the period is chosen for the export, what happens when another tenant is requested, or how a failure is reported.

The text under judgment is the reply. A "question" is an item the reply asks the requester to answer; assumptions stated without asking are not questions.

PASS if the reply asks at most four questions, and the questions together cover at least three of these four topics:
1. whether the export is synchronous (the file comes back on the click) or asynchronous (a job that finishes later);
2. how the period is specified or limited;
3. what happens when a user specifies another tenant's ID or data;
4. how a failed export is reported to the user.

FAIL if the reply asks more than four questions, asks none, or covers fewer than three of the four topics.
