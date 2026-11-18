# Changing a Suite

Read when: changing a suite's graders or cases, or when two results of the
same comparison disagree.

## Adopting a Change

- Before adopting a suite change, run the changed suite twice against the
  skill and twice against the canary.
- Adopt the change when all three conditions hold:
  - the canary still passes less often than the skill on at least as many
    graders as before;
  - the holdout score does not fall, and its failing-grader count does not
    rise;
  - any rise in score comes with closer agreement with the fixture's facts.
- After two consecutive rejected suite changes, stop changing the suite and
  keep the results so far.

## Running `eval-auditor`

`eval-auditor` is a user-scope subagent that audits a suite against result
files and proposes grader and case changes without applying them. Decide
adoption from reruns, not from its predictions.

1. Run `scripts/grade-kept` on each result file to audit, since that opens
   the kept workspaces the auditor reads.
   Completion: `grade.py` printed one line per run for each result file.
2. Write `DIR/request.md` naming the plugin directory under test (the
   deployed plugin for an in-place run, `DIR/kit` for a wrapper), its eval
   directory, and each result file with its label (skill with baseline,
   canary, older version, repeat); leave the holdout out.
   Completion: the request names the plugin directory and every result file
   with a label, and no holdout path.
3. Run
   `claude -p "Follow the audit request in DIR/request.md." --agent eval-auditor --add-dir <system temp directory> --add-dir DIR --add-dir <plugin directory> --max-budget-usd 15 --output-format json --allowedTools Read Glob Grep 'Bash(jq *)'`.
   Completion: the JSON has `"is_error": false` and `total_cost_usd` is
   recorded.
4. Apply a proposal only after rerunning as "Adopting a Change" describes.
   Completion: each proposal is marked adopted or rejected, with the rerun
   pass counts.

`--allowedTools` limits Bash to `jq`, and a `-p` run rejects any other
command without asking, which is what keeps the auditor read-only.
