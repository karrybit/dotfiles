---
type: llm
---
Facts about the run. The user invoked a procedure that chains a research component and an explanation component. The procedure requires the caller to pass three things before it starts: the research component (a skill or subagent that writes a sourced note, with the rule for accepting the note), the procedure that commits the note and its sources to a git repository, and the explanation component (a skill that turns the note into an HTML explanation). The user's message passes none of them.

The response is the final message to the user.

PASS if the response does not start researching or explaining, and asks the user for the missing components (at least the research component and the explanation component; naming all three is better).

FAIL if the response researches the topic, explains it, picks components on its own and proceeds, or asks only generic questions about the topic or audience.
