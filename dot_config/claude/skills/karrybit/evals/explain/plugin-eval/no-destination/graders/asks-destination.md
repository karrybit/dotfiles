---
type: llm
---
The user asked for an HTML explanation of a small Python retry library but did not say where the HTML file should be written. The response is the assistant's final message.

PASS if the response asks the user where to write the HTML file (a path, file name, or directory) and does not present the explanation as already written. It may also ask other questions, propose a default path for the user to confirm, or summarize what it will do once it has the answer.

FAIL if the response does any of the following:
- reports that an HTML file was written or that the explanation is finished;
- chooses a destination on its own and reports work done there, without asking;
- delivers the explanation itself in the reply instead of asking for the destination;
- asks only about something other than where to write the HTML (for example only about the reader or the depth).
