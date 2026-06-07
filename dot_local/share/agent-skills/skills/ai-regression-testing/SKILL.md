---
name: ai-regression-testing
description: Use when AI-assisted code changes need regression tests, especially after bugs, API changes, sandbox/mock paths, production-vs-test parity issues, or repeated review misses. Design deterministic tests that catch the agent's likely blind spots.
---

# AI Regression Testing

Use this skill when the same agent or model wrote code and is now reviewing it, or when a bug has already escaped an AI-assisted review.

The core risk is shared assumptions: the model can make the same mistake in implementation and review. Prefer executable tests over another prose review.

## Workflow

1. Identify the exact bug or risk, not just the changed file.
2. Write a regression contract:
   - required response fields
   - state transitions
   - error behavior
   - sandbox/mock path behavior
   - production path behavior
3. Add the smallest deterministic test that fails on the old bug.
4. Run the test before or immediately after the fix to prove it covers the failure.
5. Add parity checks when the app has multiple paths:
   - sandbox vs production
   - mock vs real provider
   - feature flag on vs off
   - API response vs frontend expectation
6. Keep the test in the repo's normal test framework. Do not create one-off scripts when a test suite exists.

## Common AI Regression Patterns

- production path fixed, sandbox path forgotten
- SELECT/query fields do not match response contract
- type errors hidden by unchecked casts or generated types
- optimistic UI update diverges from server truth
- error path returns a different shape than success path
- authorization check added to one route but not sibling routes
- test updated to match broken behavior instead of preserving the user-visible contract

## Review Checklist

Before accepting the change:

- Does the test fail for the actual previous bug?
- Does it assert behavior rather than implementation trivia?
- Does it cover all code paths the agent touched?
- Does it run without production credentials?
- Is it fast enough to run during normal verification?

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

Distilled from the ECC `ai-regression-testing` workflow, reviewed on 2026-06-06. The local version is framework-neutral and does not depend on ECC commands or hooks.
