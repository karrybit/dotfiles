---
name: docs-information-design
description: Decide what a technical document or documentation set should contain, where each piece of information belongs, and whether anything should change at all. Use when creating, restructuring, auditing, trimming, splitting, merging, or retargeting project documentation (README, guides, references, design docs, ADRs, runbooks, docs/ trees), when documenting a new feature, and when updating docs after a code change. Not for proofreading or style-only edits.
---

# Documentation information design

A good document gives its reader what their task needs, in the amount, order, and place that minimizes the reader's **total cost**: finding the information, reading it, understanding it, rebuilding context across files, acting on it, and recovering from mistakes. Length is not the measure. Deleting, compressing, moving, consolidating, adding, splitting, merging, and leaving things as they are are equal outcomes, and **no change is a passing result**.

## 1. Fix the frame

Establish these from the request, the documents, and the repository; ask only for what they cannot answer:

- **Reader and task** for each document in play: who opens it, to do what (act, look something up, understand, decide), and what they already know.
- **Mode and boundary**: audit (report only), plan (propose changes), or apply (edit). A request to fix one paragraph bounds the edit to that paragraph.
- **Existing conventions**: the doc set's layout, project instructions, and style guide.

Scale the investigation to the request. For a local edit, read the surrounding section and whatever it links to or is linked from. For work across a doc set, first inventory it: for each file, its reader, its job, what it owns, and what links to it.

## 2. Judge each piece of information

For each piece, ask two questions: does a reader of *this* document need it for their task, and is this its **home**? Being correct, interesting, or thorough does not make information needed here.

| Finding | Meaning | Usual action |
| --- | --- | --- |
| Unnecessary | Contributes nothing to the reader's task: generic background, what the reader already knows, restated headings, promotion | Delete |
| Redundant | Needed, but costs more reading than it returns | Compress |
| Duplicate | The same fact in several places | Consolidate into one home; link from the others |
| Misplaced | Needed by a different reader or document | Move; leave a link where readers here still need to find it |
| Missing | The reader cannot complete the task without it | Add, after verifying it |
| Fine | — | Keep |

**Load-bearing** information often looks redundant but carries the document: rationale, constraints and invariants, rejected alternatives and why, exceptions, warnings before irreversible actions, preconditions, known failure modes, and examples the reader will copy. Compress the wording around it, not the information itself. Every piece you remove has a known fate: deleted because no reader needs it, or moved to a named place.

Repetition earns its place when it puts something at the point of action that the reader would otherwise miss, such as a safety warning at each step where the danger arises, or a one-line recap that saves a jump to another file. Consolidate duplicated facts that can drift apart (versions, defaults, commands, limits); keep short repeated cues that point at their home.

## 3. Decide document boundaries

That a document can be split does not mean it should be. Compare split, merge, and leave-as-is:

- Do the parts serve different readers or tasks, or are they read together?
- Do they change at different rates, or have different owners?
- Would a split add navigation, link upkeep, and context rebuilding? Would a merge bury one reader's material inside another's?
- Can each fact keep exactly one home either way?

Keep the current boundary when the benefit of changing it is unclear or small. Length and heading count alone are not reasons. Document-type frameworks such as Diátaxis help tell content apart (does this help someone act or understand, learn or work?); that separation can live in sections of one file and does not require a file per type.

Create a new document only when no existing one is the right home, and link to it from where its readers already start. For a project without documentation, start with the smallest set its readers need, often a README alone; add a document when it has a distinct reader and job, not because a filename is customary.

## 4. Ground every fact

Check commands, flags, defaults, paths, configuration keys, and described behavior against the code and configuration, including statements you keep unchanged. Present as fact only what you verified. When readers need a step or fact you cannot verify, keep it in the document marked as unconfirmed rather than dropping it or guessing. Word the mark for the reader (what to check, what may differ); where the evidence was missing belongs in your report.

Records of past decisions (ADRs, changelogs, dated reports) describe what was decided at the time. When the code has moved on, mark the record superseded or flag the conflict; rewrite its decision only when the user asks.

## 5. Act within the request

- **Audit**: report problems with evidence, ordered by impact on readers. If the docs serve their readers, say that no change is needed. Leave files untouched.
- **Plan**: list the operations (what is deleted and why, what moves where, which boundaries change) before editing.
- **Apply**: make the smallest change set that reaches the goal. For a large restructure the user has not yet seen, present the plan first. Mention problems outside the boundary instead of fixing them.

When goals conflict, prefer them in this order: factual accuracy and safety; the information readers need; the requested scope and existing work; the placement and structure of the doc set; concision.

## 6. Check the result

- Walk through each affected reader's task using only the documents, including what they do when a step fails. Can they find what they need and complete the task?
- Every piece of load-bearing information is still present, moved somewhere reachable, or deliberately dropped with a stated reason.
- Every link and anchor resolves, including those pointing at moved, renamed, or deleted content.
- The diff stays inside the requested boundary.

Report briefly: what changed and why, what you deliberately left unchanged, what you could not verify, and any remaining risk.
