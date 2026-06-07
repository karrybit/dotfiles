---
name: agent-introspection-debugging
description: Use when an agent run is failing repeatedly, looping, drifting from the task, or recovering from tool, context, or environment-state failures. Capture evidence, diagnose the failure class, take the smallest safe recovery action, and report the result.
---

# Agent Introspection Debugging

Use this skill when an agent is burning tokens without progress, retrying the same action, losing the objective, or acting on stale assumptions.

This is a workflow skill. It does not reset agent state, change harness settings, or run hidden recovery steps.

## Workflow

1. Restate the current objective in one sentence.
2. Capture the failure before retrying:
   - error message or symptom
   - last successful step
   - last failed command or tool call
   - repeated pattern observed
   - assumptions about cwd, branch, files, services, permissions, or network
3. Classify the failure:
   - `logic`: wrong hypothesis or wrong target
   - `state`: stale file, branch, process, cache, or live-vs-source mismatch
   - `environment`: missing tool, stopped service, permissions, network, sandbox
   - `context`: prompt drift, duplicated plans, oversized logs, forgotten constraint
   - `policy`: blocked action, unsafe permission, approval needed
4. Run one discriminating check that can prove or falsify the classification.
5. Take the smallest reversible recovery action:
   - re-check actual filesystem, branch, process, or config state
   - narrow to one file, one failing command, or one failing test
   - trim low-signal context and keep only objective, evidence, and blocker
   - stop repeated retries and change the plan only when evidence supports it
6. If code or config changed, run the relevant verification before declaring recovery.

## Stop Conditions

Escalate to the user instead of continuing when:

- the same blocker repeats after three focused recovery attempts
- recovery requires destructive cleanup, credential changes, or broad permission changes
- evidence indicates compromised local state or possible secret exposure
- the next step would be speculative rather than evidence-seeking

## Report Format

End with:

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

Distilled from the ECC `agent-introspection-debugging` workflow, reviewed on 2026-06-06. The local version removes any dependency on the ECC repository, plugins, hooks, or MCP servers.
