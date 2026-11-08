# Failure Diagnosis

Read when: an action fails, a defect is reported, or you are about to retry,
escalate, or fix a bug.

## Diagnosing

- Treat a root cause as a hypothesis and confirm it with evidence before
  acting; a plausible story is not proof.
- Before retrying a failed action, capture the symptom, the last successful
  step, and the assumption being tested, then run one check that can falsify
  the leading hypothesis.
- Classify a failure by what the system reported, not by how the agent
  misbehaved.
- When the same blocker survives three focused recovery attempts, or the next
  step would be speculative rather than evidence-seeking, stop and escalate
  with the evidence collected.

## Fixing

- Generalize the lesson only to the level where the trigger is identifiable and
  a violation is detectable, since over-abstraction produces unactionable
  advice.
- Match analysis depth to recurrence and impact: deep root-cause work for
  recurring or high-impact defects, direct fixes for one-offs.
- Close the verification gap that let the defect through, not just the defect.
- When fixing a bug that AI-assisted work introduced or a review missed, add
  the smallest deterministic regression test that fails on the old behavior.
- In that test, cover the parallel paths the change touches (sandbox vs
  production, mock vs real provider, feature flag on vs off).
