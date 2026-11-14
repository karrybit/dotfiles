---
name: size-github-issues
description: Decide the granularity and boundaries of GitHub issues. Use when splitting a document, investigation, audit, or migration plan into issues, or when judging whether a proposed issue is too large or bundles unrelated work. Skip this skill when the current repository has its own issue-authoring policy — a repo CLAUDE.md rule, an issue template, or CONTRIBUTING guidance on issue scope and splitting — because that policy takes precedence.
---

# Sizing GitHub issues

These are defaults for repositories with no issue-authoring policy of their
own.

- Before applying anything here, check the repository for its own
  issue-authoring policy, and follow that policy when one exists.
- Before creating any issue, confirm the proposed titles and boundaries with
  the user, since issue creation is a visible, external action and the split is
  reviewed before it is published.

## Granularity

- Size each issue to an independently mergeable PR-sized unit of work, not by
  mirroring a source document's headings and not by tool or component name
  alone.
- When sub-parts are independently actionable, default to more, smaller issues
  over fewer, larger ones.
- Put two independent changes to the same tool or component but of a different
  kind (for example, version bump vs. config-content review) in separate
  issues.
- Put a core mechanism change and its optional or deferrable follow-ons in
  separate issues, even when the follow-on depends on the core change landing
  first.

## What Is Not an Issue

- Resolve a cross-cutting policy question spanning multiple concrete artifacts
  inside each concretely affected issue instead of filing it as its own issue
  with no code deliverable, so every issue ships a decision and its
  implementation together.
- Record a decision with no code deliverable right now as a caveat inside the
  nearest concrete issue's body.
- For follow-on scope that is not concretely actionable yet, file only the
  pilot or first-instance issue, validate the approach, and note in a parent or
  tracking issue that further issues will follow once it lands.

## Dependencies and Provenance

- Express a cross-issue ordering dependency as a short note in the dependent
  issue's body, not as a separate coordination or blocking issue.
- When new issues originate from an investigation or audit issue, keep that
  original issue open as a parent or tracking issue with a checklist linking
  to the new issues, since closing it loses the evidence that justified the
  split.
