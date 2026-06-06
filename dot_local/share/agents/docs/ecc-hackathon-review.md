# ECC Hackathon Repository Review

Checked: 2026-06-06
Source: `https://github.com/affaan-m/ECC`
Version observed locally: `2.0.0-rc.1`, commit `7113b5bf`
License observed: MIT

## Decision

Do not install ECC as a plugin, hook set, MCP bundle, or installer-driven
runtime. The repository is useful as expert practice material, but its runtime
surface is intentionally broad: plugins, hooks, MCP declarations, installers,
`npx`-launched tools, continuous-learning observers, and cross-harness config.

Instead, vendor only distilled, instruction-only workflows into this dotfiles
repository so they survive deletion of the local ECC clone and reproduce via
chezmoi on other machines.

## Imported Workflows

- `agent-introspection-debugging`: recover from stalled, looping, or drifting
  agent runs through failure capture, diagnosis, and contained recovery.
- `agent-architecture-audit`: audit agent and LLM apps across prompt, memory,
  tool, wrapper, retry, rendering, and persistence layers.
- `production-audit`: judge production readiness from local evidence and
  user-approved runtime checks without external audit services.
- `ai-regression-testing`: add deterministic regression tests for AI-assisted
  implementation blind spots.

## Explicitly Not Imported

- ECC Claude or Codex plugin manifests.
- ECC hook runtime and continuous-learning observers.
- ECC MCP defaults, including remote or `npx`-launched MCP servers.
- ECC install scripts and auto-update paths.
- Social, billing, media, lead, and other externally connected operator skills.

## Revalidation Triggers

Re-review before importing any additional ECC component that introduces:

- hooks or lifecycle scripts
- MCP servers
- network access
- credential or secret handling
- broad shell, write, or bypass permissions
- installer or auto-update behavior
