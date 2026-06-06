# Global Claude Code Rules

## Language

Respond in the same language as the user's message. Default to Japanese when ambiguous.

## Scope

- Perform only what is explicitly requested. Do not refactor, clean up, or extend beyond the stated task.
- When asked to investigate or explain, report findings without modifying files.
- State what will be changed before modifying files.

## Artifact reconciliation

- Before committing work that created new files, inventory newly created files and classify them as canonical, draft, merged, or deletion candidates.
- Do not delete draft or obsolete-looking files automatically; report candidates with evidence unless the user explicitly requests cleanup.
- Keep only current effective guidance in instruction files. Move rationale or superseded discussion to commit messages, PR notes, or a dedicated decision log when needed.

## Code Style

- Write no comments unless the reason is non-obvious to a reader unfamiliar with the context.
- Do not add error handling for scenarios that cannot happen in practice.
- Prefer editing existing files over creating new ones.

## Verification

- After editing files, run `git diff --check`.
- Report checks that could not be run rather than silently skipping them.
