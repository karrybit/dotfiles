---
name: pii-publish-guard
description: Use before publishing, pushing, opening a PR, sharing a diff, or making a repository public when changes may include PII, secrets, local usernames, absolute home paths, machine names, private organization names, credentials, tokens, cookies, private URLs, or other sensitive local data.
---

# PII Publish Guard

Protect the public or remote artifact before it leaves the local machine.

## Workflow

1. Identify the exact publication surface: staged diff, last commit, branch range, PR body, generated artifact, or full repository.
2. Inspect the content that will be published, not only the working tree.
3. Search for sensitive data:
   - secrets: tokens, API keys, private keys, passwords, cookies, auth headers, credentialed URLs
   - personal data: email addresses, phone numbers, home paths with real usernames, machine names, private notes
   - organizational data: private employer, customer, internal project, internal URL, or private repository names
   - local-only state: cache paths, session files, logs, histories, generated runtime outputs
4. Treat findings as blockers until classified as safe, templated, redacted, or intentionally public.
5. Prefer templating or placeholders over publishing real local values. In chezmoi source, use template variables such as `{{ .chezmoi.homeDir }}` when a live target needs a local absolute path.
6. Re-run the inspection after edits and before the publish action.

## Useful Commands

Use the narrowest command matching the publish surface:

```sh
git diff --cached
git show --stat --patch --find-renames HEAD
git diff origin/main...HEAD
rg -n --hidden --glob '!.git/**' '(/(Users|home)/[^[:space:]]+|[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}|AKIA[0-9A-Z]{16}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY|authorization:|cookie:|password|passwd|secret|token|api[_-]?key)'
```

Report what was checked, what was found, what was changed, and any remaining risk.
