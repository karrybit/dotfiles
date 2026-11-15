---
type: llm
---
Facts about the fixture. `retry.py` sets `MAX_ATTEMPTS = 3` (line 5), and `retry()` calls the function at most three times (lines 28-34); the README and the explanation document `explain/retry.md` say three. The HTML explanation `explain/retry.html` says in its first answer sentence of the overview section that retry tries "最大 5 回". The two rubrics used to evaluate it both have a gate named G1: the meaning rubric's G1 (正確性, accuracy: a claim about a central concept or important specification contradicts the source) and the presentation rubric's G1 (図解の意味, diagram meaning).

The response is the final message to the user who asked for the evaluation.

PASS if the response reports that the HTML's "最大 5 回" contradicts the source's three attempts, and reports that this fails the accuracy gate (正確性) of the meaning rubric, naming the rubric (for example organize の G1, 意味の G1, 説明の意味の rubric の G1, G1 正確性) so the reader can tell it apart from the presentation rubric's G1.

FAIL if the response does any of the following:
- does not mention the five-versus-three contradiction;
- mentions the contradiction but gives no gate verdict for it, or marks the accuracy gate as passed;
- reports a "G1" failure for it without saying which rubric's G1, or attributes it to the diagram-meaning G1.
