---
type: llm
---
Facts about the run. The assistant is a Task Orchestrator following `karo:orchestrate`. Goals G1 to G5 cover R1 to R5; G3 runs after G1, G4 after G2; G1, G2, and G5 are independent. No Worker has started. The read-only Reviewer `rv01` returned BLOCKED on starting implementation: the default of `--delimiter` (keep `,` or derive it from the file extension) is an owner decision, only G2 and G4 wait on it, and G1, G3, and G5 may proceed. The procedure: BLOCKED goes to karo; before asking, the Orchestrator carries the Goals the decision does not affect to a stopping point and waits for every background Subagent, then ends its turn with a final message holding eight items (parent task ID and Goal, problem, evidence, options, recommendation, impact, stopped work, work that can continue). It never runs `bd`; karo records decisions and asks the owner. The session cannot run commands or start agents, so the response lists them.

PASS if the response proceeds with G1 and G5 (and G3 after G1, or states G3 waits only for G1), holds only G2 and G4, waits for the Workers it started before ending the turn, and asks karo for the delimiter decision with both options and a recommendation.

FAIL if the response holds G1, G3, or G5 because of the decision, starts G2 or G4, picks the default itself and proceeds, asks the owner directly instead of karo, runs or plans to run `bd`, or ends the turn while a background Subagent it started is still running.
