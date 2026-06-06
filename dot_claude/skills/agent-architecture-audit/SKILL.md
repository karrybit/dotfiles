---
name: agent-architecture-audit
description: Use when reviewing or debugging an agent or LLM-powered application for wrapper regressions, memory pollution, tool discipline failures, hidden repair loops, context duplication, or output rendering corruption. Produce severity-ranked, evidence-backed findings and code-first fixes.
---

# Agent Architecture Audit

Use this skill for agent systems, AI features, autonomous loops, MCP-backed workflows, tool-calling apps, or memory-enabled assistants.

Check the layers that exist: system prompt, session history, long-term memory, distillation, active recall, tool selection, tool execution, tool-output interpretation, answer shaping, rendering, hidden repair loops, and persistence.

## Evidence Collection

Start from local evidence:

```sh
rg -n "system prompt|developer prompt|must use|tool_call|tool_use|mcp|memory|summar|compact|fallback|retry|repair|rewrite|completion|messages.create|chat.completions" .
```

Inspect prompt assembly, tool schemas, memory policy, retry loops, logs, and persistence paths that can reintroduce stale agent assertions.

## Findings

For each finding, record severity, symptom, mechanism, layer, evidence, and a code-first fix. Prefer fixes that enforce tool requirements in code, remove hidden repair agents, reduce duplicated context, tighten memory admission, validate tool output, and preserve structured data until final rendering.

## Output Format

Lead with severity-ranked findings, then a short architecture diagnosis, then an ordered fix plan. If no issue is found, state the evidence checked and remaining risk.

## Source

Distilled from the ECC `agent-architecture-audit` workflow, reviewed on 2026-06-06. This local copy is instruction-only.
