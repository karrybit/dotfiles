# Document Review: Criteria Frameworks and Multi-Reviewer Evidence

Last checked: 2026-07-30

Grounds document-review design (criteria sets, number of reviewers, how to split
perspectives, what to expect) in standards, editorial practice, and software
inspection experiments. Companion file: `llm-as-reviewer-evidence.md` covers the
same decisions for LLM reviewers. Collected while designing a subagent-based
review process for Obsidian notes.

Evidence grades: **★** primary text read / **▲** abstract only / **○**
second-hand, source attributed / **×** not obtained.

## Criteria frameworks

### Editing levels ★

Editorial Freelancers Association, "Editorial Service Definitions" and *Hiring an
Editor* (rev. 7-2022). Three levels:

| Level | Scope |
| --- | --- |
| Developmental | Content, organization, genre. Deliverable is a revision letter or manuscript evaluation |
| Line | Sentence and paragraph level; main aim is language and style |
| Copyediting | Spelling, grammar, usage, punctuation, cross-references, style sheet. Intensity from light (note to author) to heavy (revising text) |

Proofreading is listed separately; EFA states outright that proofreading "is not
considered editing." EFA also notes that developmental / substantive /
structural / content editor are overlapping terms used interchangeably — they are
not distinct layers.

The load-bearing principle: levels are "typically undertaken as a separate
editorial phase … done in stages," even when one person performs several. **Do
not review structure and style in one pass.**

Editors Canada, *Professional Editorial Standards* 2024: Fundamentals /
Structural / Stylistic / Copy / Proofreading. Copy editing's four standards are
Correctness, Consistency, Accuracy, Completeness. Proofreaders must "refrain from
undertaking structural, stylistic or copy editing tasks unless authorized" — role
non-overlap is a requirement, not a preference.

Origin of the concept: Van Buren & Buehler, *The Levels of Edit*, 2nd ed., JPL
1980 — five levels as cumulative subsets of nine edit types. Level 1 is heaviest,
Level 5 lightest, which inverts intuition.

### Information typing (Horn) ★

Horn, "Structured Writing as a Paradigm," in Romiszowski & Dills (eds.),
*Instructional Development: State of the Art*, 1998.

Seven information types: Procedure, Process, Concept, Structure, Classification,
Principle, Fact.

Four principles: **chunking** (information blocks, usually ≤ 7±2 sentences),
**labeling**, **relevance** (one chunk contains information relating to one main
point; nice-to-know material and examples go elsewhere with their own labels),
**consistency**.

Evidence weakness, cited by Horn himself: Clark (1993) observed that most studies
evaluated *learning outcomes* rather than retrieval speed or accuracy — 7 of 10
summarized studies on learning, only 2 on retrieval time. The single
organization-scale figure is Holding (1985), Pacific Telephone, 180 managers
trained, ~32% reduction in reading time — self-reported through supervisor
interviews, and reported by Horn himself.

### Document-type separation (Diátaxis) ★

`diataxis.fr/foundations/`. Two axes — action vs cognition, acquisition vs
application — yielding tutorial / how-to / reference / explanation, claimed as a
complete map ("the dimensions … define the terrain").

Its evidence claim is adoption ("proven in practice … hundreds of documentation
projects"), not a controlled study. The foundations page documents no failure
modes for mixing the four types.

### Minimalism (Carroll; van der Meij)

Four principles ○ (via Virtaluoto et al. 2021 Table 1, verbatim from van der Meij
& Carroll 1995 and van der Meij 2007): choose an action-oriented approach; anchor
the tool in the task domain; support error recognition and recovery; support
reading to do / to study / to locate. The authors state these are "not rules to
be followed blindly."

Turned into a review instrument ★: Virtaluoto, Suojanen, Isohella (2021),
*Technical Communication* 68(1) — three groups: core task and goal orientation /
accessibility / error management. Validation was a single 2018 workshop pilot, 18
practitioners, with no effect measurement.

Most useful operational observation ★ from that paper: heuristics about the
user's core task require SMEs and user representatives; language and structure
heuristics can be applied by non-SMEs. **This is the practical basis for
splitting review roles by required expertise rather than by topic.**

Limits ○ (attributed): Rosenbaum 1998 — works for install procedures, not all
document types. van der Meij 1992 — legal requirements turn minimalists into
maximalists. van der Meij 2017 — minimalist manuals take ~30% longer to produce.
van der Meij 2007 — the context is mainly novice software users.

× Carroll 1990 *The Nurnberg Funnel* and Carroll et al. 1987 "The Minimal Manual"
experimental numbers were not obtained. No literature was found on applying
minimalism to specification review.

### Information ordering

| Principle | Grade | What is actually established |
| --- | --- | --- |
| Progressive disclosure | ★ NN/g (Nielsen, 2006-12-03) | Show only the few most important options first. No numeric studies cited; NN/g gives no inventor or year |
| Inverted pyramid | ★ NN/g (Schade, 2018-02-11) | Most important information first, even the conclusion. The article presents no quantitative data |
| Given-new contract | × Haviland & Clark 1974 | Body not obtained. Do not cite latency figures |
| Cognitive load theory | × bodies not obtained | Sweller 1988; split-attention primary source is Tarmizi & Sweller 1988; Chandler & Sweller 1991 is the redundancy effect; expertise reversal is Kalyuga et al. 2003 |

Scope limit worth carrying forward: CLT's evidence base is instructional
material, and no literature was found that explicitly scopes or validates it for
technical or reference documents. Expertise reversal (support that helps novices
harms experts) is itself an argument against applying one criteria set to every
reviewer.

Cross-cutting gap: both Information Mapping and CLT are validated on documents
for *learning*, not documents for *looking things up*.

### Standards ★ (clause titles verified from the free preview; bodies paywalled)

**ISO/IEC/IEEE 26514:2022**, *Design and development of information for users*.
Cancels and replaces ISO/IEC 26514:2008. Scope names "reviewers of information
for users" as an intended audience.

- Clause 7 Information quality: 7.2 **Correctness** / 7.3 **Consistency** / 7.4
  **Comprehensibility** / 7.5 **Conciseness** / 7.6 **Minimalism** / 7.7
  **Accessibility**. Minimalism appears as an international-standard quality
  characteristic.
- Clause 8 Structure: includes 8.2 Modularity, 8.4 Information model, and
  separate structure requirements for conceptual (8.5), instructional (8.6) and
  reference (8.7) information — the same separation as Horn's typing and
  Diátaxis, standardized.
- Clause 6 contains 6.4 Review and 6.8 Final assembly and review.
- Family: 26511 managers / 26512 acquirers and suppliers / **26513 reviewers and
  testers** / 26515 agile / 26531 content management.

**ISO/IEC/IEEE 26513:2017**, *Requirements for testers and reviewers of
information for users* — Active, 40 pp. **The most directly relevant standard for
review design.** Its clause structure could not be obtained (×). Buy it before
claiming standard alignment.

× Not obtained: IEEE 1063 (superseded), ISO/IEC 20246:2017 *Work product reviews*
(title and date only), IEEE 1028-2008 *Software Reviews and Audits*
(Inactive-Reserved since 2019-11-07; five review types — management reviews,
technical reviews, inspections, walk-throughs, audits — ○ second-hand).

### Style guides publish copyedit-layer checklists only ★

- **Google** developer documentation style guide: no doc-review or checklist
  page. "Highlights" is a style summary. The only structure-level items are "put
  conditions before instructions" and list-type selection.
- **Microsoft** Writing Style Guide "Top 10 tips": only #4 (get to the point
  fast) is structural. Structural criteria live in the separate contributor guide
  (`/contribute/content/dotnet/dotnet-pr-review`): sample code compiles and runs;
  "the article clearly describes the goals for the reader, and those goals are
  met"; all links resolve. Draft-PR review "focus[es] on the structure of the
  article … not a thorough check for grammar and correct links" — **structural
  review is explicitly staged before copyedit.**
- **Red Hat** (`redhat-documentation.github.io/peer-review/`, updated
  2023-06-19): the only major publisher with an explicit structure-level
  checklist. Five separated lists — Language / Style / Minimalism / Structure /
  Usability. Structure includes "module types are not mixed, for example, concept
  and procedure information is separate."
- **Write the Docs** and **The Good Docs Project**: no review checklist at all.
  Write the Docs' "docs principles" is doc-set level (ARID, Skimmable, Unique,
  Cumulative, Complete, Current — "incorrect documentation is worse than missing
  documentation").
- **GitLab**, **Kubernetes SIG Docs**: process and mechanics, largely without
  quality criteria.

Implication: structure-level criteria must come from the frameworks above and
from 26514, not from vendor style guides.

## Multi-reviewer empirical evidence

### Perspective-based reading works by producing an artifact ★

Basili, Green, Laitenberger, Lanubile, Shull, Sørumgård, Zelkowitz (1996), "The
empirical investigation of Perspective-Based Reading," *Empirical Software
Engineering* 1(2):133-164, DOI 10.1007/BF00368702. NASA/GSFC SEL professionals.

**Mechanism — the part that matters most.** Each perspective *builds something*:
the tester designs test suites, the developer generates a high-level design, the
user writes the user manual, each answering fixed questions while doing so.
Defects are the places where the artifact cannot be produced. This is not "read
as if you were a tester."

Results:

| Condition | PBR | Conventional | p |
| --- | --- | --- | --- |
| Pilot / generic | 24.92 | 20.58 | 0.2148 |
| Pilot / NASA | — | — | 0.9629 |
| 1995 / generic | **32.14** | **24.64** | **0.0019** |
| 1995 / NASA | — | — | 0.4755 |

Team level (permutation test): 1995/generic p=0.0007, 1995/NASA p=0.0390; both
pilot conditions non-significant. **Two of four conditions significant.**

Design limits stated in the paper: teams were simulated by taking the union of
individual reviewers' defects *after* the experiment; no team member actually
collaborated, so meeting suppression and correction are absent.

Overlap: on the NASA documents, overlap between perspectives was much larger than
on generic ones. ATM 1995 design perspective — of 11 defects, 2 unique to that
perspective and **5 found by all three**.

Experience: correlation between PBR defect rate and experience never exceeded
35%. More experienced reviewers did not outperform less experienced ones; less
experienced reviewers followed the method more faithfully, while experienced ones
reverted to habit ("went back to what I usually do"; "trying to wear all the hats
gets confusing").

False positives ★ (same authors, UMD TR T114): similar for both methods, PBR
slightly lower but not significantly; **average cost per defect found was the
same for both.**

### Scenarios beat checklists; checklists do not beat ad hoc ★

Porter, Votta, Basili (1995), "Comparing detection methods for software
requirements inspections: a replicated experiment," *IEEE TSE* 21(6):563-575. 48
subjects, 16 teams of 3, two specifications.

| Specification | Ad hoc | Checklist | Scenario |
| --- | --- | --- | --- |
| WLMS | .43 | .41 | **.57** |
| CRUISE | .31 | .24 | **.45** |

Scenario improvement ≈35%. **Checklist reviewers were not more effective than ad
hoc reviewers**, despite the checklist targeting many defect classes. Scenario
reviewers were no worse on defects outside their scenario's scope.

**Collection meetings produced no net improvement**: gain 4.7±1.3% offset by loss
6.8±1.6% (WLMS) and 7.7±1.7% (CRUISE); net −0.9±2.2 and −1.2±1.7.

Only detection method and document explained variance significantly. **Team
composition did not.**

### Replications are mixed, and the largest ones are negative

- ▲ Miller, Wood, Roper (1998), *EMSE* 3:37-64 — broadly supports scenario >
  checklist and meetings as an ineffective detection mechanism.
- ▲ Sandahl et al. (1998), *EMSE* 3:327-354 — **could not significantly support
  scenario superiority**; found that "the requirements specification inspected,
  not the detection method," best explains variance in detection rate.
- ▲ Maldonado et al. (2006), *EMSE* 11(1):119-142 — the one document where PBR
  failed to beat checklist was the document where two perspectives found similar
  defects. **Complementarity is the active ingredient.**
- ★ Regnell, Runeson, Thelin (2000), "Are the Perspectives Really Different?",
  *EMSE* 5(4):331-356 — perspectives did **not** find different defect sets:
  χ²=33.951, df=46, p=0.906 and χ²=41.676, df=46, p=0.654. Ten of 24 defects
  (41.7%) were found by all three perspectives; inter-perspective correlations
  were significantly positive (.258–.601). Conclusion: combining perspectives
  "may not give higher defect coverage compared to reading with only one
  perspective." Limits: students, no ad-hoc control, 5 per cell.
- ○ Sample-size pattern (via Thelin et al. 2003): significant at n=12+13, 25+26,
  66; non-significant at n=48, n=30, and at the three largest — **n=223
  (Lanubile & Visaggio 2000), n=169 (Biffl 2001), n=177 (Halling 2001).**

### Team size: two is the baseline, the third reviewer adds almost nothing

- ★ Porter, Siy, Toman, Votta (1997), *IEEE TSE* 23(6):329-346. AT&T/Lucent 5ESS
  compiler project, 11 trained developers with 5+ years' experience, 18 months,
  **88 code inspections**, reviewer count manipulated at 1 / 2 / 4. **"No
  difference between 2-person and 4-person inspections, but both performed better
  than 1-person."** Splitting one large team into two small ones was not an
  effective reorganization. Two sessions with repair between them doubled elapsed
  time.
- ★ Rigby & Bird (2013), ESEC/FSE:202-212, across Android, Chromium OS,
  Microsoft Bing/Office/SQL, AMD, Lucent, and 6 OSS projects. "Convergent
  Practice 4: **Two reviewers find an optimal number of defects.**" Median active
  reviewers = 2 everywhere; Microsoft invites 3–4 but median actual participation
  is 2. With more active reviewers, the increase in comments is "very small" and
  there is no increase in review rounds. Common practice: invite 3–4 and let the
  review flow.
- ○ Buck 1981 (IBM TR 21): no difference in defects found among 3-, 4-, and
  5-person teams. ○ Sauer et al. 2000, *IEEE TSE* 26(1):1-14 — consensus that two
  inspectors find an optimal number (primary source × not obtained).
- ★ Kantorowitz, Guttman, Arzi (1997), *Requirements Engineering* 2(3):152-164 —
  N-fold, 8 experiments, all 3-person teams. Measured detection rate 35.1% (N=1)
  → 77.8% (N=9) on the railway document; 38.9% → 83.3% (N=7); 36% → 76.4% (N=8).
  Shape derived from their model at skill 0.9: N=1 40.5% → N=2 **56.7% (+16.2)**
  → N=3 **65.0% (+8.3)** → N=4 70.0% (+5.0) → N=5 73.3% (+3.3). **The ceiling is
  set by reviewer skill, not by count.** Direct overlap measurement (7 teams, 18
  defects): no defect was found by all teams, most by fewer than half, and 3 of
  18 by none.
- ○ Schneider, Martin, Tsai (1992), *ACM TOSEM* 1(2):188-204, via Porter/Siy/Votta
  1996 — 27 students, 9 teams of 3, 99 seeded defects. Union of 9 teams found
  **78% vs a single-team mean of 35%**; two teams found 1.5× one team; **no
  defect was found by all teams.** Cost: 324 person-hours over 1.5 weeks. Team
  effectiveness ranged 22%–50%.
- ★ Faulkner (2003), *Behavior Research Methods, Instruments, & Computers*
  35(3):379-383 — counterexample to "five users is enough." 60 users, 45 problems
  total; Monte Carlo over 100 five-user sets gave mean 85% but **range
  55%–100%**; 10 users mean 95% with minimum 80%; 20 users never below 95%.
  **Small-panel figures are averages hiding extreme variance.**

### Overlap, false positives, and what aggregation is for

- ★ Johnson & Tjahjono (1996), Univ. of Hawaii CSDL TR 96-06; published as "Does
  Every Inspection Really Need a Meeting?", *EMSE* 3(1), 1998. 72 undergraduates,
  24 three-person groups, real (face-to-face) vs nominal (pooled individual)
  groups. **Overlap 30%: about a third of defects were found by more than one
  reviewer, so ~70% were found by only one.** Effectiveness: real 43% vs nominal
  46%, no significant difference. **False positives: nominal 22% vs real 5.3% —
  the meeting's value was filtering, not finding.** Cost ≈46 extra person-minutes
  per 3-person session. 72% of subjects believed meeting-based review was more
  productive "although the major review metrics suggest the opposite."
- ★ Porter, Siy, Mockus, Votta (1998), *ACM TOSEM* 7(1):41-79. 88 inspections, 130
  collection meetings, 233 individual preparation reports, with an independent
  observer at 125 of 130 meetings.
  - Operational definitions worth reusing: **true defect** = author was forced to
    make a change affecting execution; **soft maintenance issue** = fixed but not
    that; **false positive** = no action needed at all.
  - Lucent (TSE 1997 version): of issues recorded at collection, 22% false
    positive / 60% soft maintenance / 18% true defect. **About half of issues
    reported during individual preparation turn out to be false positives.** Only
    ~13% concern defects impairing delivered functionality. (The NASA SEL-94-006
    preliminary version reports 18 / 57 / 25 — the versions differ, so cite the
    version.)
  - **Core conclusion: inputs (reviewers, authors, code units) explain far more of
    the variance in defect detection than process structure, leading to "the
    conclusion that better defect detection techniques, not better process
    structure, are the key to improving inspection effectiveness."** A specific
    reviewer's presence was a major factor in all models. Preparation time
    correlated only 0.26 with defects found.
- ★ Hatton (2008), "Testing the Value of Checklists in Code Inspections," *IEEE
  Software* 25(4):82-88. **238 individual inspections** by practising engineers.
  Checklist 13.97 (SD 5.27, n=106) vs none 13.40 (SD 5.00, n=132), **z≈0.055 —
  not significant even at the 10% level**, and the same null in experienced and
  inexperienced subgroups. Individuals found 53% of defects, two-person teams 76%
  (+23pt). **The best inspector was ≈10× the worst.**
- ★ Gonçalves, Fregnan, Baum, Schneider, Bacchelli (2022), *EMSE* 27:99. **67
  professional Java developers**: ad hoc (29) vs 18-item checklist (23) vs guided
  checklist (15). **Median defects found was zero in every treatment × task
  cell.** On the largest change the ad-hoc control had the highest mean (8.55%)
  and the most heavily guided condition the lowest (5.93%), non-significant; all
  Tukey CIs contain 0. **The guided condition roughly doubled review time.**
- ○ Czerwonka, Greiler, Tilford (2015), ICSE SEIP, Microsoft: only ~15% of
  reviewer comments indicate possible defects; ≥50% concern long-term
  maintainability; without prior exposure to the code, authors judge only ~33% of
  comments useful, rising to ~67% on the third review of the same area. **A
  4-page experience report with no sample size or statistical tests — cite as an
  industry claim, not a measurement.**
- ★ Beller, Bacchelli, Zaidman, Juergens (2014), MSR: 75% of changes concern
  evolvability, 25% functionality. **They deliberately exclude false positives,
  so this study says nothing about FP rates.**
- ★ Bacchelli & Bird (2013), ICSE:712-721: of 570 comments, code improvements 165
  (29%), defects 78 (14%). Of 873 programmers, 91% say reviewing unfamiliar files
  takes longer and 82% say familiar reviewers give different feedback. **Their
  recommendation runs opposite to specialization: broaden developers'
  understanding.**
- ▲ Daun & Brings (2023), EASE'23:339-347, "Aggregating N-fold Requirements
  Inspection Results." 22 N-fold groups of 4–5 reviewers. More reviewers yield
  more defects **and more false positives**; "simple aggregation of all results
  leads to a number of false positives that can actually harm the verification
  task," while tailored aggregation strategies help considerably. **× body not
  obtained; the most directly relevant modern study — buy if this decision
  matters.**

### Rates and effectiveness for planning ★

Wagner, "A Literature Survey of the Quality Economics of Defect-Detection
Techniques," arXiv:1612.04590 (aggregates multiple studies).

- Inspection effectiveness: min 8.5%, mean 34.14%, **median 30%**, max 92.7%. "A
  very stable average value close to the median of about 30%. However, the range
  of the values is huge."
- Efficiency: 0.16–6.0 defects per person-hour, mean 1.87, median 1.18.
- Effort: design inspection 8.75 person-hours/KLOC vs code 11.15 — **design
  inspection costs about half as much as code inspection**, attributed to design
  documents being more abstract and easier to understand.
- ○ Gilb & Graham, *Software Inspection* (1993): **optimal inspection rate ≈ 1
  page (300 words) per 1±0.8 hours.** Effects of deviating from this optimum are
  not well understood. Not directly transferable to Japanese text, but the order
  of magnitude — one page per hour, not several pages per hour — is decisive for
  planning.

### Over-specialization: asserted often, measured rarely

- ★ Porter et al. (1995) found no tunnel vision: reviewers were equally effective
  on defects that no scenario targeted.
- ★ Thelin, Runeson, Wohlin (2003), *IEEE TSE* 29(8):687-704 — the one measured
  reversal. Usage-based reading beat an 18-item checklist overall (5.6 vs 4.1
  defects/hour, p=0.042) and on severe class A defects (p=0.013 / 0.036), but
  **the checklist beat UBR on class C defects outside UBR's scope (1.4 vs 0.9,
  p=0.268 — report as direction only).** χ² p=0.001 that the two methods found
  different defects. **Yet the nominal-team simulation in §7.5 found that "the
  combination teams do not outperform the UBR teams" — different defects did not
  translate into team-level gain.**
- ★ Dunsmore, Roper, Wood (2003), *IEEE TSE* 29(8):677-686 — broad checklist 7.30
  > systematic abstraction-driven 6.17 > use-case 5.74 defects;
  Kruskal-Wallis p=0.088. **The narrower methods took longer (72 / 77 / 82
  minutes) and found less.** Stated power 0.4.
- ○ "Checklists should not exceed one page (~25 items)" is an assertion (Dunsmore
  et al., ICSE 2002, agreeing with Chernak), not a measurement. **No study
  manipulates checklist length as an independent variable.**
- ○ Tunnel-vision claims are asserted as design rationale without measurement,
  e.g. Laitenberger & DeBaud (2000), *JSS* 50(1):5-31.

## Design implications that follow directly

1. **Two reviewers is the baseline; the third adds ~nothing.** Independently
   replicated in industrial code inspection, contemporary code review, IBM, and
   the N-fold model.
2. **Define a perspective by the artifact it must produce, not the stance it
   should adopt.** This is the mechanism behind PBR's +30%.
3. **Verify complementarity before adding a perspective.** Perspectives can fail
   to find different defects (Regnell 2000), and even when they demonstrably do,
   combining them may not help (Thelin 2003).
4. **Do not expect checklists to work.** Three independent studies show no
   measured effect, and heavier guidance costs time.
5. **Aggregation's value is filtering, not finding** (22% → 5.3% false
   positives). If reviewers are added, design the aggregation step at the same
   time (Daun & Brings 2023).
6. **Inputs beat process structure.** Who reviews and what is reviewed explain
   more variance than how criteria are split; best-to-worst reviewer spread ≈10×.
7. **Never assume one pass finds everything.** Median effectiveness 30% (range
   8.5–92.7%); ~1 page per hour; roughly half of individually reported issues are
   false positives.
8. **Split perspectives by required expertise** (Virtaluoto 2021): core-task
   criteria need domain knowledge; language and structure criteria do not.
9. **Stage structure before style** (EFA, Editors Canada, Microsoft draft-PR
   review).

Applicability limit: all of the multi-reviewer evidence is from requirements
documents and code with seeded defects, reviewed by students or professionals.
Transfer to prose notes, and to LLM reviewers, is an extrapolation.

## Do not cite

- **CMOS** for "light / medium / heavy copyediting." Chapter 2 has a levels
  section (§2.48 in 17th ed., renumbered §2.53 in 18th) but the body is paywalled
  and unverified; the light/medium/heavy trio is popularly attributed to
  Einsohn's *Copyeditor's Handbook*, also unverified. Cite EFA for the intensity
  axis. Citation trap: §2.48 in CMOS 18 is an unrelated section.
- **ACES** for an editing-levels taxonomy — it publishes none (verified via its
  full sitemap).
- **quality.arc42.org** for ISO/IEC/IEEE 26514 quality characteristics — it lists
  "Usability" and "Clarity," which are not Clause 7 subclause titles.
- **Votta's meeting-gain figure** without checking the original: the literature
  reports 4%, 5%, and 10%, and the sample size is inconsistent across Votta's own
  co-authored papers (13 vs 50 design inspections).
- **"Progressive disclosure originated with Carroll"** — NN/g attributes no
  inventor or year.
- **Beller et al. 2014** for false-positive rates — the category is excluded by
  design.
- **A single "22% false positive" figure for Lucent** — the TSE 1997 and NASA
  SEL-94-006 versions of the same dataset report 22/60/18 and 18/57/25. State the
  version.

## Corrections to commonly repeated claims

- Horn 1998 has **7 information types and 4 principles**. There is no "7
  principles" list in that source.
- The **split-attention effect**'s primary source is Tarmizi & Sweller (1988).
  Chandler & Sweller (1991), *Cognition and Instruction* 8(4):293-332, is the
  primary source for the **redundancy effect** (Exp. 3–5).
- **Williams & Farkas (1992)** reject guided exploration as doctrine; their
  argument is that it backfires for users with real work and substitutes for real
  tasks for novices — not that minimalism "breaks when readers cannot act." The
  verified source for limits on retrieval use is Farkas & Williams (1990) on
  omission.

## Sources

Standards and practice guides

- ISO/IEC/IEEE 26514:2022, *Systems and software engineering — Design and
  development of information for users*. First edition 2022-01. Clause titles from
  the official free preview.
- ISO/IEC/IEEE 26513:2017, *Requirements for testers and reviewers of information
  for users*. Active, 40 pp. Content not obtained.
- Editorial Freelancers Association, "Editorial Service Definitions";
  *Hiring an Editor: A Guide for New Authors*, rev. 7-2022.
- Editors Canada, *Professional Editorial Standards*, 2024.
- Van Buren & Buehler, *The Levels of Edit*, 2nd ed., JPL, 1980.
- Red Hat Customer Content Services peer review checklists,
  https://redhat-documentation.github.io/peer-review/ (updated 2023-06-19).
- Google developer documentation style guide, https://developers.google.com/style
  (Highlights page updated 2025-04-02); "Editing" module,
  https://developers.google.com/tech-writing/two/editing (2025-03-31).
- Microsoft Writing Style Guide, "Top 10 tips for Microsoft style and voice,"
  https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice
  (ms.date 2026-07-02); .NET docs PR review,
  https://learn.microsoft.com/en-us/contribute/content/dotnet/dotnet-pr-review
  (2025-06-17).
- Write the Docs, "Documentation principles,"
  https://www.writethedocs.org/guide/writing/docs-principles/
- Diátaxis, https://diataxis.fr/foundations/ and https://diataxis.fr/compass/
- Nielsen Norman Group: "Progressive Disclosure" (2006-12-03); "Inverted
  Pyramid" (2018-02-11); "How to Conduct a Heuristic Evaluation" (2023-06-25);
  "Why You Only Need to Test with 5 Users" (2000-03-18).

Frameworks

- Horn, "Structured Writing as a Paradigm," in Romiszowski & Dills (eds.),
  *Instructional Development: State of the Art*, Educational Technology
  Publications, 1998 (Stanford self-archived PDF).
- Virtaluoto, Suojanen, Isohella, "Minimalism Heuristics Revisited: Developing a
  Practical Review Tool," *Technical Communication* 68(1), 2021 (Univ. of Vaasa
  self-archived).
- van der Meij & Carroll, *Technical Communication* 42(2):243-261, 1995;
  *Minimalism Beyond the Nurnberg Funnel*, MIT Press, 1998, pp.19-53.

Experiments

- Basili et al., *EMSE* 1(2):133-164, 1996, DOI 10.1007/BF00368702; UMD TR T114
  "Studies on Reading Techniques."
- Porter, Votta, Basili, *IEEE TSE* 21(6):563-575, 1995.
- Porter, Siy, Toman, Votta, *IEEE TSE* 23(6):329-346, 1997 (read via UMD
  CS-TR-3760).
- Porter, Siy, Mockus, Votta, *ACM TOSEM* 7(1):41-79, 1998 (author draft).
- Regnell, Runeson, Thelin, *EMSE* 5(4):331-356, 2000.
- Thelin, Runeson, Wohlin, *IEEE TSE* 29(8):687-704, 2003.
- Dunsmore, Roper, Wood, *IEEE TSE* 29(8):677-686, 2003.
- Kantorowitz, Guttman, Arzi, *Requirements Engineering* 2(3):152-164, 1997.
- Johnson & Tjahjono, Univ. of Hawaii CSDL TR 96-06, 1996; *EMSE* 3(1), 1998.
- Hatton, *IEEE Software* 25(4):82-88, 2008.
- Gonçalves, Fregnan, Baum, Schneider, Bacchelli, *EMSE* 27:99, 2022 (open
  access).
- Rigby & Bird, ESEC/FSE 2013:202-212.
- Faulkner, *Behavior Research Methods, Instruments, & Computers* 35(3):379-383,
  2003.
- Wagner, arXiv:1612.04590.
- Second-hand only: Schneider/Martin/Tsai TOSEM 1992; Buck 1981; Sauer et al.
  2000; Miller et al. 1998; Sandahl et al. 1998; Maldonado et al. 2006;
  Czerwonka et al. 2015; Daun & Brings 2023; Fagan 1976/1986 (roles and stages
  unverified — buy IEEE 1028 or ISO/IEC 20246 if the exact definitions matter).

Access note: ACM DL, IEEE Xplore, iso.org, Springer, and tandfonline returned
403 from this environment. Several load-bearing papers exist only as
second-hand summaries here.

Revalidation trigger: recheck when ISO/IEC/IEEE 26513 or 20246 becomes
accessible (both would replace second-hand role definitions with primary ones);
when a study manipulates the number of independent reviewers or checklist length
as an independent variable (both are current gaps); when Daun & Brings 2023
becomes obtainable; or when applying these numbers to a document type other than
requirements, code, or short prose notes.
