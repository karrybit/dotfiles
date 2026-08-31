---
name: size-github-issues
description: Decide the granularity and boundaries of GitHub issues. Use when splitting a document, investigation, audit, or migration plan into issues, or when judging whether a proposed issue is too large or bundles unrelated work. Skip this skill when the current repository has its own issue-authoring policy — a repo CLAUDE.md rule, an issue template, or CONTRIBUTING guidance on issue scope and splitting — because that policy takes precedence.
---

# Sizing GitHub issues

These are defaults for repositories with no issue-authoring policy of their own.
A repo-specific policy always wins; check for one before applying anything here.

## Granularity

- Size each issue to an independently mergeable PR-sized unit of work — not by
  mirroring a source document's headings, and not by tool/component name alone.
  Default to more, smaller issues over fewer, larger ones whenever the sub-parts
  are independently actionable.
- Two changes to the same tool/component but of a different kind (e.g. version
  bump vs. config-content review) belong in separate issues when independent —
  don't bundle by component name alone.
- A core mechanism change and its optional/deferrable follow-ons belong in
  separate issues even when the follow-on depends on the core change landing
  first.

## What is not an issue

- A cross-cutting policy question spanning multiple concrete artifacts should not
  become its own issue with no code deliverable — resolve it locally inside each
  concretely affected issue instead, so every issue ships a decision and its
  implementation together.
- A decision with no code deliverable right now is not an issue — record it as a
  caveat inside the nearest concrete issue's body.
- Don't pre-create speculative issues for follow-on scope that isn't concretely
  actionable yet. File the pilot/first-instance issue, validate the approach, and
  note in a parent/tracking issue that further issues will follow once it lands.

## Dependencies and provenance

- Express cross-issue ordering dependencies as a short note in the dependent
  issue's body, not as a separate coordination/blocking issue.
- When new issues originate from an investigation/audit issue, keep that original
  issue open as a parent/tracking issue with a checklist linking to the new
  issues, rather than closing it — closing it loses the evidence that justified
  the split.

## Before creating anything

Confirm the proposed titles and boundaries with the user. Issue creation is a
visible, external action, so the split is reviewed before it is published.
