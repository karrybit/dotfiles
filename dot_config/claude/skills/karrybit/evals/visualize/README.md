# karrybit:visualize comprehension evaluation

Measures whether a reader who sees only an HTML explanation can answer the questions that matter, so that two versions of the `visualize` request template can be compared on the same source. It complements `exact_skills/visualize/rubric.md`, whose evaluator checks meaning, figures, and display quality but answers no questions. The "依頼の型を直すとき" section of `exact_skills/visualize/SKILL.md` runs both.

`exact_skills/organize/rubric.md` also has its evaluator answer questions (its steps 1 and 3), but the same evaluator writes the questions from the source and then answers them from the document, so an answer can come from its memory of the source. Here the questions, the answers, and the matching are three separate runs, and the answerer never sees the source.

Three roles keep the answers from leaking out of the source or the answer key:

| Role | Runs as | Sees | Writes |
| --- | --- | --- | --- |
| Question setter | a new subagent with `setter.md`, once per source and version | the source only | `questions.md` and `key.md` |
| Opportunity spotter | a new subagent with `spotter.md`, once per source | the source only | `opportunities.md` |
| Answerer | `ask.sh` with `answerer.md`, once per HTML (or explanation document) | `questions.md` and the page as screenshots, or `document.md` | `out.json` |
| Matcher | `ask.sh` with `matcher.md`, once per answer set | `key.md` and the answers, without the version label | `out.json` |

`ask.sh` runs `claude -p` with `--restricted --strict-mcp-config --tools Read` in the given folder, so the only tool is `Read` and it cannot open files outside the folder; denied reads are counted in its summary. The folder's path is the run's working directory and is visible to the answerer and the matcher, so name every folder on that path with a neutral run id (`r01`, `r02`, …) and keep the mapping from run id to version outside it.

## Files

- `setter.md`: the request template for the question setter.
- `spotter.md`: the request template for the opportunity spotter, which lists, with an importance, the places in the source where a figure beside the text would make a relation easier to see, trace, compare, or bound. Every `rubric.md` evaluator of the source gets the same `opportunities.md`, so its 観点 5 and gate S8 judge every version against the same list.
- `answerer.md`, `answerer.schema.json`: the answerer's prompt and output schema (answer, where it was found, which element type, how a figure helped, where it hesitated).
- `matcher.md`, `matcher.schema.json`: the matcher's prompt and output schema (`正答`, `部分`, `誤り`, `答えなし`, points hit, misconception, whether the misconception came from a figure).
- `shoot.mjs`: opens a page in headless Chrome at 1280×900 with reduced motion, opens every `<details>`, and saves one screenshot per 800 px of scroll; it stops with an error when a screen is not at its scroll position. Chrome cannot start inside the command sandbox, so run it outside.
- `ask.sh`: runs one isolated `claude -p` and prints the reported cost, the number of `Read` calls, and the number of denied calls.

## Running

1. Fill `setter.md` for the source and version and hand it to a new subagent; keep `questions.md` and `key.md` outside every folder given to an answerer. Have the owner read the question list once and replace one or two questions, then freeze both files. Fill `spotter.md` for the source and hand it to another new subagent; have the owner read `opportunities.md` once, then freeze it.
   Completion: `questions.md` and `key.md` hold the same ids in the same order, and every opportunity in `opportunities.md` has an importance.
2. For each HTML, run `node shoot.mjs <page.html> <dir>/view`, copy `questions.md` into `<dir>/view`, and run `bash ask.sh <dir>/view answerer.md answerer.schema.json claude-sonnet-5-5 1.5` three times, each in its own `<dir>` holding the same screenshots. For the explanation-document control, put the Markdown in `<dir>/view` as `document.md` instead of the screenshots.
   Completion: `<dir>/view/out.json` holds one answer per question, and the summary shows 0 denied calls.
3. For each answer set, copy `key.md` and `<dir>/view/out.json` (as `answers.json`) into `<dir>/match`, and run `bash ask.sh <dir>/match matcher.md matcher.schema.json claude-opus-5-5 0.5`.
   Completion: `<dir>/match/out.json` holds one verdict per question.
4. Record per HTML the mean and the range over its three runs of: key points hit, verdict counts (score = `正答` 1, `部分` 0.5), misconceptions and the figure-borne ones, questions not found, questions answered from a figure, and the answerer's `Read` count. Compare versions only on the same questions, and treat a difference within the noise in "What It Separates" as no difference.
   Completion: a table with these values for every HTML compared.

## What It Separates

Measured on one figure-rich HTML explanation of an operations runbook (13 sections, 10 SVG figures, 22 screens) with 8 questions and 29 key points, answerer `claude-sonnet-5-5`, matcher `claude-opus-5-5`:

Each input ran three times; the cells give the mean and the range.

| Input | Key points hit | Score | Answers taken from a figure | `Read` calls |
| --- | --- | --- | --- | --- |
| The page | 22.0 (21–23) | 5.5 (5–6) | 5.0 (5–5) | 18.0 (17–19) |
| The page with every `<svg>` removed | 21.0 (20–23) | 5.7 (5.5–6) | 0 (0–0) | 19.3 (18–21) |
| The page with its last 6 of 13 sections removed | 18.0 (17–19) | 4.2 (4–4.5) | 5.7 (5–6) | 13.7 (13–14) |

- Treat a difference of means smaller than the range of either page's three runs as noise. The range depends on the page: on 12 explanations of 6 sources (27–32 key points each), the three runs of one page spread by 0 to 6 key points, against 2 on the page in the table above.
- Removing the second half of the sections lowers the mean by 4 key points, more than either range (2), and leaves one question unanswered in every run, so the key points separate pages that do and do not carry an answer.
- Removing every figure moves the mean by 1 key point, within both ranges, because this page also states most of its figures' relations in text. The answerer's correctness measures what a page says, not how much its figures help; figure use shows in "answers taken from a figure", which drops from 5 to 0.
- No run had a denied read. One answerer run cost 0.11–0.60 USD (longer pages cost more) and one matcher run 0.11–0.22 USD.

## Limits

- The answerer is a model, not a person. It reads every word on a screen, so it gains less from a figure's layout than a person does and can answer from a list just as well; a gap in correct answers understates a gap in human comprehension.
- The setter and the producer of the HTML may be the same model, so their questions can resemble each other; the owner's replacement in Running step 1 offsets this.
- Screenshots show the page with every `<details>` open and no other interaction.
- The spotter is a model too and can miss an opportunity; each `rubric.md` evaluator adds the ones it finds, and a missed opportunity it reports beyond the frozen list counts only when it states the reader's harm.
