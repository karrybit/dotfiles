# Provenance

- origin: official
- source: Anthropic Claude Code webapp-testing skill
- source_url: https://github.com/anthropics/skills/tree/main/skills/webapp-testing
- license: Apache-2.0
- reviewed_at: 2026-07-23
- sync_policy: sync
- migration_target: official standalone package when available
- notes: Playwright workflow and helper script shared across agents. Upstream
  diff reviewed 2026-07-23: local copy adds When-to-use / Expected-outputs
  sections; upstream changes minor. Kept vendored because the anthropics/skills
  marketplace distributes it only inside the broad example-skills bundle.
