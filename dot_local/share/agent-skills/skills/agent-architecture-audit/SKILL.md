---
name: agent-architecture-audit
description: Use when reviewing or debugging an agent or LLM-powered application for wrapper regressions, memory pollution, tool discipline failures, hidden repair loops, context duplication, or output rendering corruption. Produce severity-ranked, evidence-backed findings and code-first fixes.
---

# Agent Architecture Audit

Use this skill for agent systems, AI features, autonomous loops, MCP-backed workflows, tool-calling apps, or memory-enabled assistants.

Do not use this for ordinary application code review. Use a narrower security, testing, or framework skill when the issue is not agent-specific.

## Audit Layers

Check the layers that exist in the target system:

1. System prompt and developer instructions
2. Session history and summarized history
3. Long-term memory and retrieval admission
4. Distillation or compaction artifacts
5. Active recall and re-summary layers
6. Tool selection and routing
7. Tool execution and result validation
8. Tool-output interpretation
9. Answer shaping and structured-output enforcement
10. UI, API, CLI, streaming, or markdown rendering
11. Hidden repair, retry, fallback, or second-pass LLM calls
12. Persistence, caches, and reused generated artifacts

## Evidence Collection

Start from local evidence:

```sh
rg -n "system prompt|developer prompt|must use|tool_call|tool_use|mcp|memory|summar|compact|fallback|retry|repair|rewrite|completion|messages.create|chat.completions" .
```

Then inspect:

- prompt assembly and instruction precedence
- tool schemas and server-side enforcement
- memory write, retrieval, ranking, and deletion policy
- retry loops and fallback model calls
- logs that compare internal output with user-visible output
- persistence paths that can reintroduce stale agent assertions

## Findings

For each finding, record:

- severity: `critical`, `high`, `medium`, or `low`
- symptom seen by the user
- mechanism causing it
- layer number
- evidence with file and line when available
- code-first fix

Prefer fixes in this order:

1. Enforce required tool use in code, not only prompt text.
2. Remove or make explicit hidden repair and retry agents.
3. Reduce duplicated context across prompt, memory, history, and summaries.
4. Tighten memory admission so user corrections outrank agent assertions.
5. Validate tool outputs before acting on them.
6. Preserve structured internal data until final rendering.

## Output Format

Lead with severity-ranked findings, then a short architecture diagnosis, then an ordered fix plan. If no issue is found, say what evidence was checked and what risk remains untested.

## Source

Distilled from the ECC `agent-architecture-audit` workflow, reviewed on 2026-06-06. The local version is instruction-only and does not install ECC plugin, hook, MCP, or runtime components.
