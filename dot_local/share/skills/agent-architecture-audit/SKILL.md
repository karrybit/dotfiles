---
name: agent-architecture-audit
description: Use when reviewing or debugging an agent or LLM-powered application for wrapper regressions, memory pollution, tool discipline failures, hidden repair loops, context duplication, or output rendering corruption. Produce severity-ranked, evidence-backed findings and code-first fixes.
---

# Agent Architecture Audit

## When to Invoke

Use this skill when the subject under review contains at least one of:

- An LLM or AI model (including embedded or API-backed models)
- Tool-calling, function-calling, or MCP-backed workflows
- An autonomous loop, agent orchestrator, or planner
- Memory storage, retrieval, summarization, or compaction
- A prompt assembly pipeline (system prompt + history + retrieved context)
- Streaming, structured output, or multi-modal rendering of LLM responses

Typical trigger phrases: "audit my agent", "why is the LLM rewriting the answer", "tool call is silently failing", "memory is leaking old assertions", "hidden retry loop", "compaction is losing context".

## When NOT to Use

Do not invoke this skill when the target has no LLM, agent, or tool-calling component. Redirect to a more appropriate skill instead:

- General web application security (SQL injection, XSS, auth) → use `security-review`
- Ordinary code quality or correctness → use `code-review`
- Test coverage or TDD → use `tdd`
- CI/CD pipeline failures unrelated to LLM components → use `diagnose`

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

Structure the response as follows:

```
## Findings

| Severity | Layer | Symptom | Mechanism | Evidence |
|----------|-------|---------|-----------|----------|
| critical | 11    | ...     | ...       | file:line |

## Architecture Diagnosis

One paragraph summarizing the structural root cause across findings.

## Fix Plan (ordered)

1. <code-first fix for finding 1>
2. <code-first fix for finding 2>
...
```

If no issue is found, list what evidence was checked (files, patterns) and what risk remains untested due to access limitations.

## Source

Distilled from the ECC `agent-architecture-audit` workflow, reviewed on 2026-06-06. The local version is instruction-only and does not install ECC plugin, hook, MCP, or runtime components.
