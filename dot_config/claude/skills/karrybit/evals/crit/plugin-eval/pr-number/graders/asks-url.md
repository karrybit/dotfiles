---
type: llm
---
Facts about the run. The user asked to comment on "PR 123" with crit and gave neither the repository nor the PR's URL. The procedure the assistant follows opens a GitHub PR by its URL, and asks the user for the URL when only a number is given.

The response is the final message to the user.

PASS if the response asks the user for the PR's URL (or for the repository together with the number) before opening anything.

FAIL if the response guesses a repository or URL, or presents a command for opening the PR as ready to run without asking.
