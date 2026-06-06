---
name: agent-introspection-debugging
description: Use when an agent run is failing repeatedly, looping, drifting from the task, or recovering from tool, context, or environment-state failures. Capture evidence, diagnose the failure class, take the smallest safe recovery action, and report the result.
---

# Agent Introspection Debugging

Use this skill when an agent is burning tokens without progress, retrying the same action, losing the objective, or acting on stale assumptions.

This is a workflow skill. It does not reset agent state, change harness settings, or run hidden recovery steps.

## Workflow

1. Restate the current objective in one sentence.
2. Capture the failure before retrying: error or symptom, last successful step, last failed tool call, repeated pattern, and environment assumptions.
3. Classify the failure as `logic`, `state`, `environment`, `context`, or `policy`.
4. Run one discriminating check that can prove or falsify the classification.
5. Take the smallest reversible recovery action.
6. If code or config changed, run the relevant verification before declaring recovery.

## Stop Conditions

Escalate instead of continuing when the same blocker repeats after three focused recovery attempts, recovery requires destructive cleanup or credential changes, evidence indicates possible compromise, or the next step would be speculative.

## Report Format

```markdown
## Agent Debug Report
- Objective:
- Failure pattern:
- Root-cause hypothesis:
- Check run:
- Recovery action:
- Result: success | partial | blocked
- Remaining risk:
```

## Source

Distilled from the ECC `agent-introspection-debugging` workflow, reviewed on 2026-06-06. This local copy has no dependency on the ECC repository, plugins, hooks, or MCP servers.
