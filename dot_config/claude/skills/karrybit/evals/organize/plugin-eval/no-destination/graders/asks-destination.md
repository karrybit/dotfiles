---
type: llm
---
Facts about the run. The user asked for a Markdown explanation document of the repository's job queue and did not say where to write it.

The response is the final message to the user.

PASS if the response asks the user where to write the document (a path, file name, or location) and has not written or presented the finished document.

FAIL if the response does not ask for the destination, picks a destination itself and reports the document as written, or presents the explanation document in the message.
