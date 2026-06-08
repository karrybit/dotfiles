# Agentic Development Candidate Actions

Date: 2026-06-08

## Short-Term Trials (coding-agent track)

All are low reversal cost and currently proposals only — implementation is a
separate scope requiring explicit user approval.

1. Fresh-context "diff reviewer" subagent + pre-completion verification step.
   - Source: Claude Code sub-agents doc; okhlopkov/boringbot pattern.
   - Verify: run on a real diff; confirm it surfaces a known-omitted edge case.

2. Move "run `git diff --check` after edits" + chezmoi guardrails from prose
   AGENTS.md rules into a PostToolUse/Stop hook in settings.json.
   - Source: Claude Code hooks doc.
   - Verify: make an edit; confirm the hook fires and reports/blocks as intended.
   - Rationale: matches the user's standing "prefer hooks/tests over prose"
     principle.

3. Author skills under the agentskills.io open standard so one SKILL.md serves
   both Claude Code (`~/.claude/skills`) and Codex (`~/.agents/skills`).
   - Source: Claude Code skills doc; Codex skills doc.
   - Verify: same SKILL.md invoked successfully in both tools.

4. Use Codex named permission profiles (`--profile deep-review`) + granular
   approval_policy for review-heavy sessions.
   - Source: Codex manual; Codex changelog.
   - Verify: launch with profile; confirm sandbox/approval overlay applies.

## Strategic Watch Items (agentic-software-delivery track)

1. Issue-tracker-as-control-plane convergence (Symphony/Linear, Copilot/GitHub
   Issues, Kiro spec-as-unit). Next check 2026-07-08.
2. Org-managed agent identity/credential/policy (AgentCore) vs decentralized
   local (Claude Code/MCP). Next check 2026-07-08.
3. MCP as cross-vendor standard without a policy layer for deep delegation.
   Next check 2026-07-08.
4. Pre-execution approval for irreversible ops as the only viable autonomous-
   agent gate. Next check 2026-08-08.
5. Review/validation as the binding constraint; vendor benchmark scores overstate
   readiness. Next check 2026-09-08.

## Cross-track handoffs (delivery -> coding-agent, local trials)

- Risk-based PR/diff triage heuristic: flag large or config-touching diffs for
  heavier review (AIDev static signals, AUC 0.957).
- Destructive-op pre-execution confirmation hook at the single-user level.

## Next Candidate Review

- 2026-07-08 monthly pass: retry unverified first-party sources under network
  approval; re-score `investigate` entries; decide which trials to schedule.
