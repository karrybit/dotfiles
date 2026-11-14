# LLM as Reviewer: Criteria Decomposition, Panel Size, and Failure Modes

Last checked: 2026-07-30

Grounds the design of LLM-based review (how many criteria, how many agents, which
model, what context to withhold, what precision to expect) in measured results.
Companion file: `document-review-evidence.md` covers the same decisions from
standards and human software-inspection experiments; the two agree on more than
they disagree.

Evidence grades: **★** primary text or PDF tables read / **▲** abstract only /
**○** second-hand, source attributed / **【V】** vendor self-report.

## Methodological warning, recorded first

While gathering this material, a WebFetch summarizer **fabricated numbers from a
PDF**: it reported "validity 62% → 76%" for one paper when the PDF contained no
such figures (the actual table read 62.5 / 71.4 / 88.9). PDF extraction had
failed and the summarizer confabulated. Load-bearing numbers below were re-read
from PDFs directly.

Practical consequence: prefer `arxiv.org/html/<id>` (no version suffix) or
`ar5iv.labs.arxiv.org/html/<id>`; for PDFs, save and extract text with
`pypdf`/`pdfminer.six` and read table cells, rather than trusting a summarizer.

## Does splitting criteria help?

**Yes, but the gain comes from one criterion per inference pass — not from listing
criteria.** This is the most convergent finding here.

- ★ **TICK** (arXiv:2410.03608), Table 4, judge = GPT-4o, exact-match agreement:
  Direct Scoring 0.464 → Check-then-Score (builds a checklist but emits one
  score) 0.487 → TICK (answers each checklist item separately, then aggregates)
  0.522. **Of the +5.8pt total, +2.3pt comes from having the checklist as context
  and +3.5pt from judging items one at a time.**
- ○ **Multi-Crit** (arXiv:2405.01724): bundling all criteria into one prompt drops
  GPT-4o's tradeoff sensitivity from 66.02 to 38.83; per-attribute evaluation
  gives Krippendorff α 0.597 vs 0.513 bundled.
- ▲ **When Gradients Collide** (arXiv:2605.26046): task focus drops **59% (9.0 →
  3.7 of 10)** when one model must give feedback on multiple criteria jointly;
  separately, naively merging separately optimized single-objective instructions
  into one prompt degrades Spearman ρ **0.305 → 0.220**.

### How many criteria

- ○ **AdaRubric** (arXiv:2603.21362) ablation: N=1 r=0.61 (holistic), **N=5
  r=0.79 (optimal), N>6 declining**, attributed to "evaluator instruction-following
  saturation … dimensions become increasingly overlapping."
- ▲/○ **Branch-Solve-Merge** (arXiv:2310.15123, NAACL 2024): branch-count ablation
  2 → 0.50, 3 → 0.52, **4 → 0.53**, 5 → 0.52. Prompt design caps at 5 criteria.
- **Gap:** almost no study manipulates criterion count monotonically. AdaRubric
  and BSM are effectively the only two. Treat "4–5 then degradation" as
  suggestive, not established.

### What decomposition does and does not buy

- ★ **FineSurE** (ACL 2024, aclanthology 2024.acl-long.51): on faithfulness,
  FineSurE (GPT-4) does **not** beat G-Eval (Pearson 0.833 vs 0.841); what
  decomposition adds is a *new capability* — sentence-level localization (bAcc
  86.4%). On completeness it gains a lot (Pearson 0.688 vs 0.314), but via an
  external structure (keyfact alignment); letting the LLM generate keyfacts drops
  it to 0.571. Table 2: identifying the **error type** averages only **42.2%**
  (random 14.3%) — the paper notes LLMs are good at the binary hallucination
  decision but "still make numerous mistakes in accurately identifying the exact
  error type."
- ▲ **CheckEval** (arXiv:2403.18771): converting Likert scales to boolean
  sub-questions improved **inter-evaluator agreement by 0.45** across 12 models.
  Its headline benefit is reproducibility, not human correlation.
- ○ **LLM-Rubric** (ACL 2024 / arXiv:2501.00274): 8 of 9 dimensions degrade
  results if removed — but the LLM's *raw* per-dimension judgments correlate
  ρ=0.030–0.059 with humans (humans on the same 9 questions: ρ=0.72). What bridged
  the gap was a supervised calibration network, not the decomposition.
- ○ **Self-generated criteria fail for quality discrimination**: SVR/RRD — LLM-
  generated rubrics gain only +3.8 over no rubric (55.2 → 59.0; human rubric
  83.1), and naive auto-generation scores **12.7pt below no rubric** (55.6 →
  42.9). Diagnosis: self-generated rubrics *describe* good responses, while
  effective criteria must *discriminate*. For instruction-following tasks,
  LLM-generated checklists are fine (TICK).
- **Gains shrink as the base model gets stronger** — BSM: LLaMA-2-7B +2,
  Vicuna-33B +5, LLaMA-2-70B +12, **GPT-4 +3**. The advertised "up to 26%" is a
  weak-model ceiling.
- ○ **Binary beats graded**: Autorubric — binary 87.0% exact agreement (κ=0.642)
  vs ordinal 38–58%.

## Does adding evaluators help?

**Recall yes, precision no. Saturation at 3–7, and gains over the best single
evaluator are small.**

- ★ **PoLL / "Replacing Judges with Juries"** (arXiv:2404.18796, Cohere). Panel =
  Command R (35B) + Claude-3 Haiku + GPT-3.5, **7× cheaper** than GPT-4. But
  reading Table 1 carefully: individual small models beat GPT-4 on this task
  (Haiku 0.749 / 0.894 / 0.873 vs GPT-4 0.627 / 0.841 / 0.830), and the paper says
  GPT-4 "is one of the weaker evaluators on this particular task setup." **PoLL
  does not clearly beat the best panel member — on HotpotQA Haiku 0.873 > PoLL
  0.867.** On Chatbot Arena rank correlation PoLL (0.917/0.778) does beat all
  singles. Conclusion: PoLL supports "small models can replace a large one
  cheaply," not "panels beat singles."
- ○ **SLMJury** (arXiv:2606.07810): 16 SLM judges (0.6B–14B) × 10 benchmarks,
  N=64,824 judgments per config. **Best 3-judge ensemble 89.61% vs best single
  89.55% — +0.06pt.** Conclusion: "a jury provides marginal gains; a single strong
  SLM is more cost-effective."
- ○ **Non-zero error floor** (arXiv:2602.08003): under uniform correlation,
  ensemble error converges to a floor **regardless of ensemble size**. Measured
  error correlation ≈0.7–0.8 within a model family, 0.4–0.5 across families; a
  cross-family ensemble averaging 72% accuracy beat a same-family (all-GPT)
  ensemble averaging 81%. Practical optimum k = 3–7. **Diversity of model family
  is the thing that pays, not count.**
- ○ **CARE** (arXiv:2603.00039): judges show correlated errors from shared latent
  confounders, so majority voting "provides little gain or even amplifies
  systematic mistakes"; confounder-aware aggregation cut errors 26.8% vs majority
  vote. Latent confounder correlates with verbosity at ρ≈0.49.
- ○ **Where adding does pay — recall** (arXiv:2606.19749, 74 papers with injected
  errors): best single system recall 71.6%, **union of 6 models 83.3% (+11.7pt)**.
  But operationally, **71% of downvoted comments were "unhelpful false positives or
  nitpicks."**
- ★ **Debate loses to independent sampling** (arXiv:2310.01798, GSM8K, matched
  response counts): multi-agent debate 83.2 / 83.2 / 83.0 vs self-consistency
  majority vote 82.5 / **85.3** / **88.2** at 3 / 6 / 9 responses.
- ★ **More rounds are actively harmful** (arXiv:2603.16244): 30 artifacts, 150
  injected errors. Single pass — 9.3 findings, 2.64 TP, 5.23 FP, precision 0.297,
  F1 0.376. Adding one round: **TP +0.39, FP +3.24, duplicates +2.27**; precision
  falls to 0.168–0.204. Named mechanisms: *false positive pressure* (reviewers
  fabricate findings once real errors are exhausted) and *review target drift*.
  Conclusion: "The optimal number of CCR review rounds is one." **Single-author
  unreviewed preprint — see limits below.**

## Failure modes

### Biases

| Bias | Measured | Caveat |
| --- | --- | --- |
| Position ★ (arXiv:2306.05685, Table 2) | Consistency: Claude-v1 23.8%, GPT-3.5 46.2%, GPT-4 65.0% (77.5% few-shot) | **n=80, and the pairs are two temperature-0.7 samples from the same model — near-ties maximize position bias.** With large quality gaps, conflict rate was 5.0% (Wang et al.) |
| Verbosity ★ (same paper, Table 3) | Repetitive-list attack failure: Claude-v1 91.3%, GPT-3.5 91.3%, GPT-4 8.7% | **n=23, i.e. 21/23 and 2/23** |
| Length ▲ (arXiv:2404.04475) | Length-controlled AlpacaEval raises Spearman vs Chatbot Arena 0.94 → 0.98; ○ prompting for verbosity moves GPT-4 baseline win rate across 22.9%–64.3% (~41pt), 41.9%–51.6% after control | — |
| Self-preference ○ (arXiv:2404.13076) | Self-recognition accuracy: GPT-4 73.5% zero-shot, >90% after 500-example fine-tuning; self-recognition correlates linearly with self-preference | **The paper does not report a single percentage for the size of self-preference.** Do not quote "GPT-4 rates itself X% higher" |
| Sycophancy ★ (arXiv:2310.13548) | Claude 1.3 wrongly admits mistakes on **98%** of questions; GPT-4 42%; accuracy drops up to 27% when a wrong answer is suggested | ○ SycEval (arXiv:2502.08177): overall 58.19% sycophancy, but **43.52% progressive (toward correct) vs 14.66% regressive**, persistence 78.5% |
| Reproducibility ○ (arXiv:2606.13685) | Re-running flips pairwise preference **13.6%** on average; 28% of questions flip >20%, max 56%; semantically equivalent prompt rewrites change the conclusion in **25%** of cases; **11 repetitions needed to recover a criterion judgment with 95% confidence** | — |

Two correctives worth keeping: ○ **Zheng et al.'s "GPT-4 favors itself 10%,
Claude-v1 25%" is disavowed by its own authors** ("our study cannot determine
whether the models exhibit a self-enhancement bias"). And ○ **humans show the
same biases** (arXiv:2402.10669): authority-bias attack success — humans 0.39,
Claude-2 0.89, PaLM-2 0.29; beauty bias humans 0.38; fallacy oversight GPT-4 0.94
> **humans 0.79** > LLaMA2-70B 0.45. "Only LLMs are biased" is false.

### False positives — separate three layers that get conflated

| Layer | Measures | Representative values |
| --- | --- | --- |
| Precision | Findings that are real problems | Academic benchmarks **2.79–15.39%**; CodeRabbit real-world **13.2%**【V】; Google sets 40–70% as a *tunable threshold* |
| Usefulness | Humans judge it helpful | Google AutoCommenter target 80%, independent raters **60%** |
| Adoption | Led to an actual change | Google **7.5%** of all comments; Beko case 73.8% |

High adoption with low precision is not a contradiction — bad findings are simply
dropped silently.

- ★ **SWR-Bench** (arXiv:2509.01494), 1,000 hand-verified GitHub PRs: PR-Review
  precision 15.39 / recall 24.06 / F1 18.73; four other approaches all **below 10%
  precision**; best combination 16.65%. Self-aggregation (n=10) lifts F1 18.73 →
  21.91 — still F1 22%. ○ "Only 27 change-points overlapped in five runs of the
  same model."
- ★ **Human-AI Synergy in Agentic Code Review** (arXiv:2603.15911) — largest real
  dataset here: **278,790 inline review conversations, 300 OSS projects, 54,330
  closed PRs.** AI agents made 88,011 suggestions with **16.6% adoption**; human
  reviewers 25,673 with **56.5%** (39.9pt gap). **"Agents produce incorrect
  suggestions in 28.7% of cases."** Cause identified: not seeing project context
  (existing namespace declarations, build configurations, prior review
  decisions), "leading it to flag a defect that does not exist." Explicitly:
  "Incorporating project-specific context reduces incorrect suggestions."
- ○ **Security code review** (arXiv:2401.16310), 549 files: best GPT-4 config
  truly identified defects in **5.50%** of cases, 14.45% including partially
  useful, and **38.52% provided zero useful information (misleading)**.
- ○ **Industry vs claims** (arXiv:2604.03196), 19,450 PRs: 12 of 13 code-review
  agents have signal ratio below 60%; Copilot 19.79%. Merge rate CRA-only 45.20%
  vs human-only 68.37%.
- ○ **Google** (ICSE-SEIP 2024) — the most instructive design decision: "a minimum
  precision of 70% was too conservative"; reducing to 50% "increased the absolute
  recall value without reducing user satisfaction"; with reviewer approve/reject
  UI they "reduce the target precision further to **40%**." Production funnel:
  confident 49.0% → accepted by reviewer 33.1% → previewed 10.7% → **applied
  7.5%**. Excluding suggestions >5 lines from the comment cut thumbs-down 8.5% →
  6.7%.
- ○ **AutoCommenter** (arXiv:2405.13565): useful ratio 54% → 66% → 80% target met
  (60% by independent raters). **But the A/B test detected no statistically
  significant change in code-review duration, active time, or comment-response
  iterations.** ○ Beko (arXiv:2412.18531), 4,335 PRs: 73.8% of comments resolved,
  developer rating 3.46/5, **yet PR close time worsened 5h52m → 8h20m
  (p≪0.001)**.

### "Must find something" pressure fabricates defects

The most direct answer to whether review prompts should demand findings.

- ○ **Systematic overcorrection** (arXiv:2603.00539) — rate at which *correct*
  code is judged defective, by prompt demand:

  | Model / benchmark | Verdict only | + explanation | + explanation + fix |
  | --- | --- | --- | --- |
  | GPT-4o / HumanEval | 26.2% | 58.5% | **73.2%** |
  | GPT-4o / MBPP | 35.9% | 74.1% | **87.9%** |
  | Claude-4.5-Sonnet / MBPP | 58.5% | — | 62.3% |
  | Llama-3.1-8B / MBPP | 74.7% | — | 88.2% |

- ○ **Independent replication** (arXiv:2508.12358): with a three-part prompt
  (verdict + explanation + fix), GPT-4o's requirement-conformance recognition on
  HumanEval was **11.0%** — it judged 89% of correct implementations as violating
  the spec. Gemini-2.0-Flash 53.0%, Claude-3.5-Sonnet 67.0%.

### False premises are accepted unless you ask

○ **PCBench** (arXiv:2505.23715), 3,600 problems, 15 LLMs. Proactive premise
critique rate (unprompted) vs assisted (told to verify premises): o4-mini 4.0% →
74.2%; GPT-4o 11.0% → 57.4%; DeepSeek-R1 19.6% → 67.7%; Claude-3.7-Sonnet 36.2%
→ 69.8%; DeepSeek-V3 40.5% → 68.8%. **Unprompted, 60–96% of flawed premises pass
through; instructing the model to check premises is a 2–10× difference.**
Related: ○ CREPE (arXiv:2211.17257) — 25% of naturally occurring forum questions
contain a false presupposition.

## Mitigations that actually worked

Every measured success couples the LLM to a fact outside itself.

| Mitigation | Effect | Source |
| --- | --- | --- |
| Static analysis + LLM, two stage | precision **0.28 → 0.93**, removes 94–98% of FPs, recall 0.75–0.88 retained | ○ arXiv:2601.18844 (Tencent, 433 alarms, 76% baseline FP rate; open Qwen-3-Coder was the best cost/performance) |
| Static confirmation | "reduces two-thirds of false positives"; precision >90% on token contracts, 57.14% on large projects | ▲ GPTScan, arXiv:2308.03314, ICSE 2024 |
| Decomposed data-flow verification | precision 91.03% / recall 74.00%; **sanitization stage alone +21.99% precision** | ▲ LLMSAN, EMNLP Findings 2024 |
| Executing the proposed fix as a filter | false-rejection 88.7% → 40.0% (GPT-4o/MBPP), 90.8% → 23.6% (Llama-3.1-8B) | ○ arXiv:2603.00539 |
| Giving a reference answer | math-grading failure 70% → 15% | ★ arXiv:2306.05685 |
| Reference-based over reference-free | Prometheus-2-7B 0.425 → 0.545; 8x7B 0.411 → 0.555; GPT-4 0.616 → 0.679. In Prometheus 1, removing the rubric costs 0.860 → 0.837 but **removing the reference answer costs 0.860 → 0.642** | ○ arXiv:2405.01535 |
| Adversarial stage gates | kills 79–83% of candidate findings | ○ arXiv:2604.19049 |
| Position-swap calibration | GPT-4 accuracy 52.7% → 62.5% (humans 71.7%) | ○ arXiv:2305.17926 |
| **Self-critique with no external signal** | **worse**: GPT-4 GSM8K 95.5% → 91.5% → 89.0%; GPT-3.5 CommonSenseQA 75.8% → 38.1% | ★ arXiv:2310.01798 — all six conditions flat or worse |

Limit on mitigation: ○ **BadScientist** (arXiv:2510.18003) — fabricated papers are
accepted by LLM reviewers 67.0–82.0% of the time; o4-mini gave accept-level scores
to **100%** of papers about which it had itself raised concerns; ensembling gave
"only marginal improvements, with detection barely exceeding random chance."

## Withholding context

**Two kinds of context must be separated.** Withholding the *generation process*
helps; withholding *facts about the subject* hurts.

- ○ **Cross-Context Review** (arXiv:2603.12123) — the only study directly testing
  this design. 30 artifacts (code / technical documents / presentation scripts),
  150 injected errors, Claude Opus 4.6, 360 reviews, 5-criterion checklist:

  | Condition | Precision | Recall | F1 |
  | --- | --- | --- | --- |
  | Context-free separate session | **31.5%** | **27.1%** | **28.6%** |
  | Subagent **with** context | 27.4% | 21.8% | 23.8% |
  | Same-session self-review | 25.8% | 24.2% | 24.6% |
  | Iterated self-review | 21.0% | 22.7% | 21.7% |

  Context-free vs with-context p=0.004 (d=0.57); vs self-review p=0.008; vs
  iterated p<0.001. The author's inference: since re-reviewing does not help,
  **what works is the separation of context, not the act of reviewing again.**

  **Limits, which matter:** single-author unreviewed preprint, single model,
  injected rather than naturally occurring defects, no human baseline, no
  false-positive analysis on clean artifacts, and a **language confound** (the
  self-review conditions were in Korean, the context-free and subagent conditions
  in English — the context-free vs subagent comparison is unconfounded, the others
  are not). Parallel reviewers were not tested in the main experiment.

- Opposite direction ★ arXiv:2603.15911 (above): missing *project* context is the
  identified cause of nonexistent defects being flagged, and adding it reduces
  them.
- ○ **Refute-or-Promote** (arXiv:2604.19049) makes the split explicit as "context
  asymmetry": give the attacker only the claim, not the proposer's reasoning.
  "Cold-start agents that independently reach a different conclusion provide
  higher-value signal than consensus among informed agents." Background: curl's
  bug bounty closed after AI submissions pushed the confirmation rate below 5%.
- Self-evaluation is compromised by capability, not only by context: ○
  arXiv:2404.13076 — GPT-4 identifies its own output with 73.5% accuracy, and
  self-recognition strength correlates with self-preference strength.

## Model selection

- ★ **The threshold is instruction-tuned ~70B class, not raw size.** FineSurE
  Table 5, sentence-level faithfulness (bAcc / Pearson / prompt-following rate):
  Phi-2 2.7B **48.1% / −0.108 / 50.4%**; Mixtral-8x7B base 50.7% / −0.023 /
  63.1%; Llama2-70B 56.5% / 0.133 / 86.2%; Mixtral-8x7B-Instruct 78.7% / 0.708 /
  88.9%; **Llama3-70B-Instruct 92.0% / 0.844 / 98.3%**; GPT-4-turbo 86.4% / 0.833
  / 98.1%; GPT-4-omni 91.8% / 0.855. Small and non-instruct models land at random
  or negative correlation, and Phi-2 followed the prompt format only half the
  time.
- ○ **Domain matters more than size for small models** (SLMJury): math 92–97% for
  top SLMs but general reasoning 76–80%; Qwen2.5-7B 95.9% on math vs **58.7%** on
  general reasoning (37.2pt gap). Open-ended scoring: fluency ρ 0.36–0.42,
  coherence 0.53–0.62. **Prose-comprehension review sits in the weakest region for
  small models.**
- ○ Thinking modes help small models on reasoning (arXiv:2509.13332): Qwen3-4B
  Chat Hard 60.09% → 78.78%; but 0.6B falls below 50% (worse than random) on Chat
  Hard and Safety. Whether to emit reasoning is domain-dependent, not
  model-dependent: quick verdicts win 2–7% on math judging, reasoning wins up to
  23% on general tasks.
- ○ **The filter stage can be small if the facts are supplied**: Tencent's
  LLM4PFA reached precision 0.93 with open Qwen-3-Coder as the best
  cost/performance. This holds only when external facts are already in hand — not
  when the reviewer must go retrieve them.

## Design implications that follow directly

1. **Separate discovery from adjudication.** Parallelism buys recall (+11.7pt for
   6 models); precision only improves when adjudication checks against external
   facts (0.28 → 0.93).
2. **One criterion per inference pass, 4–5 criteria at most**, each answered as a
   binary.
3. **One round. Never iterate.** +0.39 TP against +3.24 FP per added round.
4. **Do not add evaluators past ~3, and only across model families** — same-family
   error correlation 0.7–0.8 pins the ensemble to an error floor.
5. **Never instruct "you must report findings" or demand explanation plus fix** —
   monotonically increases false rejection of correct material (26.2% → 73.2%).
   Instruct instead that reporting nothing is acceptable.
6. **Say "check the premises" explicitly** — 2–10× difference.
7. **Withhold the generation process; supply the facts about the subject.**
8. **Do not economize on the model for discovery**; economize on the number of
   agents. Prose review is where small models fail worst.
9. **Design for low precision instead of chasing high precision** — Google
   deliberately lowered its target from 70% to 40% and built a reject-before-it-
   reaches-the-author UI. Expect ~30% precision at best.
10. **Never treat a single judgment as a measurement** — 13.6% of pairwise
    verdicts flip on re-run; 11 repetitions for 95% recovery.

## Convergence with the human-inspection literature

`document-review-evidence.md` reaches the same conclusions from 1976–2006
experiments on people: two reviewers is the baseline and the third adds ~nothing;
checklists show no measured effect while artifact-producing perspectives do;
aggregation's value is false-positive filtering (22% → 5.3%); inputs matter more
than process structure; median detection is 30%. **Where the two bodies disagree,
the human literature is better powered** — and its verdict against checklists is
the one that should override prompt designs built as criteria lists.

## Do not cite

- **Zheng et al. (2306.05685) for self-enhancement bias percentages** — the
  authors disavow them.
- **A single percentage for self-preference size** from arXiv:2404.13076 — it
  reports normalized confidence, not a percentage.
- **Graphite's "<3% false-positive rate"**【V】— no methodology disclosed, and the
  same vendor elsewhere states "industry 5–15%, ours 5–8%."
- **Greptile's catch-rate benchmark**【V】as evidence about precision — its own
  footnote states false positives, style suggestions, and unrelated comments did
  not affect the score. It measures recall only.
- **Beller et al. 2014** for false-positive rates — the category is excluded by
  design.
- **Self-Refine (arXiv:2303.17651) "~20% improvement" against arXiv:2310.01798
  without stating conditions** — the latter isolates *reasoning tasks with no
  external feedback*. The two are not directly comparable.
- **Position-bias figures as general** — n=80 near-ties; verbosity figures are
  n=23.
- Any number here about **DIAGPaper's "62% → 76%"** — that was the fabricated
  value described at the top of this file.

## Sources

Primary text or PDF tables read: arXiv:2404.18796 (PoLL); arXiv:2310.01798
(self-correction, debate vs self-consistency); arXiv:2306.05685 (MT-Bench);
arXiv:2310.13548 (sycophancy); aclanthology 2024.acl-long.51 (FineSurE);
arXiv:2509.01494 (SWR-Bench); arXiv:2603.15911 (Human-AI synergy);
arXiv:2603.16244 (More Rounds); arXiv:2603.12123 (Cross-Context Review, also
HTML); arXiv:2303.16634 (G-Eval, abstract); arXiv:2403.18771 (CheckEval,
abstract); arXiv:2404.04475 (length-controlled AlpacaEval, abstract).

Second-hand or HTML-summary only, with IDs for later verification:
arXiv:2410.03608 (TICK); arXiv:2405.01724 (Multi-Crit); arXiv:2605.26046 (When
Gradients Collide); arXiv:2603.21362 (AdaRubric); arXiv:2310.15123 (BSM);
arXiv:2501.00274 (LLM-Rubric); arXiv:2606.07810 (SLMJury); arXiv:2602.08003
(ensemble selection); arXiv:2603.00039 (CARE); arXiv:2606.19749 (agentic review
benchmark); arXiv:2601.18844 (Tencent LLM4PFA); arXiv:2308.03314 (GPTScan);
EMNLP Findings 2024 (LLMSAN, aclanthology 2024.findings-emnlp.217);
arXiv:2603.00539 and arXiv:2508.12358 (overcorrection); arXiv:2505.23715
(PCBench); arXiv:2211.17257 (CREPE); arXiv:2404.13076 (self-preference);
arXiv:2502.08177 (SycEval); arXiv:2606.13685 (reproducibility);
arXiv:2402.10669 (humans as judges); arXiv:2401.16310 (security code review);
arXiv:2604.03196 (industry claims); arXiv:2405.13565 (AutoCommenter);
arXiv:2412.18531 (Beko); arXiv:2405.01535 (Prometheus 2); arXiv:2305.17926
(judge calibration); arXiv:2604.19049 (Refute-or-Promote); arXiv:2510.18003
(BadScientist); arXiv:2509.13332 (thinking small judges); Google ICSE-SEIP 2024;
CodeRabbit and Greptile vendor posts【V】.

ID corrections found during collection: arXiv:2505.23274 does not exist (PCBench
is **2505.23715**); arXiv:2307.02394 is FalseQA, while (QA)^2 is **2212.10003**;
Themis is **2406.18365**.

Revalidation trigger: recheck before relying on the Cross-Context Review or More
Rounds numbers (both single-author unreviewed preprints — replace with peer-
reviewed replications when available); when a study measures precision and recall
as a function of the number of parallel independent reviewers (the current gap
most relevant to this design); on any major model generation change, since the
model-selection thresholds and bias magnitudes here are generation-specific; and
if criterion-count ablations beyond AdaRubric and BSM appear.
