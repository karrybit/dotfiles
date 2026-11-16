# karrybit:visualize comprehension evaluation

Measures whether a reader who sees only an HTML explanation can answer the questions that matter, so that two versions of the `visualize` request template can be compared on the same source. It complements `exact_skills/visualize/rubric.md`, whose evaluator checks meaning, figures, and display quality but answers no questions. `SKILL.md`'s "依頼の型を直すとき" runs both.

Three roles keep the answers from leaking out of the source or the answer key:

| Role | Runs as | Sees | Writes |
| --- | --- | --- | --- |
| Question setter | a new subagent with `setter.md`, once per source and version | the source only | `questions.md` and `key.md` |
| Answerer | `ask.sh` with `answerer.md`, once per HTML (or explanation document) | `questions.md` and the page as screenshots, or `document.md` | `out.json` |
| Matcher | `ask.sh` with `matcher.md`, once per answer set | `key.md` and the answers, without the version label | `out.json` |

`ask.sh` runs `claude -p` with `--restricted --strict-mcp-config --tools Read` in the given folder, so the only tool is `Read` and it cannot open files outside the folder; denied reads are counted in its summary.

## Files

- `setter.md`: the request template for the question setter.
- `answerer.md`, `answerer.schema.json`: the answerer's prompt and output schema (answer, where it was found, which element type, how a figure helped, where it hesitated).
- `matcher.md`, `matcher.schema.json`: the matcher's prompt and output schema (`正答`, `部分`, `誤り`, `答えなし`, points hit, misconception, whether the misconception came from a figure).
- `shoot.mjs`: opens a page in headless Chrome at 1280×900, opens every `<details>`, and saves one screenshot per 800 px of scroll. Chrome cannot start inside the command sandbox, so run it outside.
- `ask.sh`: runs one isolated `claude -p` and prints the reported cost, the number of `Read` calls, and the number of denied calls.

## Running

1. Fill `setter.md` for the source and version and hand it to a new subagent; keep `questions.md` and `key.md` outside every folder given to an answerer. Have the owner read the question list once and replace one or two questions, then freeze both files.
   Completion: `questions.md` and `key.md` hold the same ids in the same order.
2. For each HTML, run `node shoot.mjs <page.html> <dir>/view`, copy `questions.md` into `<dir>/view`, and run `bash ask.sh <dir>/view answerer.md answerer.schema.json claude-sonnet-5-5 1.5`. For the explanation-document control, put the Markdown in `<dir>/view` as `document.md` instead of the screenshots.
   Completion: `<dir>/view/out.json` holds one answer per question, and the summary shows 0 denied calls.
3. For each answer set, copy `key.md` and `<dir>/view/out.json` (as `answers.json`) into `<dir>/match`, and run `bash ask.sh <dir>/match matcher.md matcher.schema.json claude-opus-5-5 0.5`.
   Completion: `<dir>/match/out.json` holds one verdict per question.
4. Record per HTML: key points hit, verdict counts (score = `正答` 1, `部分` 0.5), misconceptions and the figure-borne ones, questions not found, questions answered from a figure, and the answerer's `Read` count. Compare versions only on the same questions, and treat a difference within the noise in "What It Separates" as no difference.
   Completion: a table with these values for every HTML compared.

## What It Separates

Measured on one figure-rich HTML explanation of an operations runbook (13 sections, 10 SVG figures, 22 screens) with 8 questions and 29 key points, answerer `claude-sonnet-5-5`, matcher `claude-opus-5-5`:

| Input | Key points hit | Score | Answers taken from a figure | `Read` calls |
| --- | --- | --- | --- | --- |
| The page, 3 runs | 23–24 | 6–6.5 | 4–5 | 19 |
| The page with every `<svg>` removed | 20 | 5.5 | 0 | 17 |
| The page with its last 6 of 13 sections removed | 18 | 4.5 | 4 | 13 |

- Treat a difference of 2 key points or fewer on 29 as noise: the same page spread over 23–25 in seven runs of these and earlier drafts of the prompts.
- Removing the second half of the sections drops 5–6 key points and leaves one question unanswered, so the key points separate pages that do and do not carry an answer.
- Removing every figure is weaker: one run lost the question whose answer is a decision order drawn as a flow (4 key points), and an earlier-draft run lost none, because this page also states most of its figures' relations in text. The answerer's correctness mostly measures what a page says; figure use shows in "answers taken from a figure", which drops to 0.
- No run had a denied read. One answerer run cost 0.13–0.19 USD and one matcher run 0.11–0.14 USD.

## Limits

- The answerer is a model, not a person. It reads every word on a screen, so it gains less from a figure's layout than a person does and can answer from a list just as well; a gap in correct answers understates a gap in human comprehension.
- The setter and the producer of the HTML may be the same model, so their questions can resemble each other; the owner's replacement in Running step 1 offsets this.
- Screenshots show the page with every `<details>` open and no other interaction.
