---
name: ai-regression-testing
description: Use when AI-assisted code changes need regression tests, especially after bugs, API changes, sandbox/mock paths, production-vs-test parity issues, or repeated review misses. Design deterministic tests that catch the agent's likely blind spots.
---

# AI Regression Testing

Use this skill when the same agent or model wrote code and is now reviewing it, or when a bug has already escaped an AI-assisted review.

The core risk is shared assumptions: the model can make the same mistake in implementation and review. Prefer executable tests over another prose review.

## Workflow

1. Identify the exact bug or risk.
2. Write a regression contract covering required fields, state transitions, error behavior, sandbox/mock behavior, and production behavior.
3. Add the smallest deterministic test that fails on the old bug.
4. Run the test before or immediately after the fix to prove it covers the failure.
5. Add parity checks for sandbox vs production, mock vs real provider, feature flag on vs off, and API response vs frontend expectation.
6. Keep the test in the repo's normal test framework.

## Common AI Regression Patterns

- production path fixed, sandbox path forgotten
- query fields do not match response contract
- type errors hidden by unchecked casts
- optimistic UI update diverges from server truth
- error path returns a different shape than success path
- authorization check added to one route but not sibling routes
- test updated to match broken behavior

## Output Format

```markdown
## AI Regression Test Plan
- Bug/risk:
- Contract:
- Test added or proposed:
- Old failure mode:
- Paths covered:
- Verification command:
```

## Source

Distilled from the ECC `ai-regression-testing` workflow, reviewed on 2026-06-06. This local copy is framework-neutral and does not depend on ECC commands or hooks.
