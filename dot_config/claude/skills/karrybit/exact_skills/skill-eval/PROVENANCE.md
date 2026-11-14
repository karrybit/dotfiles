# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-11-14
- notes: Procedure and scripts for evaluating an unchanged skill with `claude plugin eval`, built on the Claude Code Plugin Evals documentation (<https://code.claude.com/docs/en/plugin-evals.md>) and `claude plugin eval --help`. No upstream text is vendored. The caveats in the reference files (judge votes moving between repeats, `--case` keeping only its last value, the kept workspace layout, `--allow-tools` for gated tools) were observed while running the karrybit:docs-information-design suite. The evaluation data stays in `evals/<skill name>/` at the evaluated skill's plugin root; the `eval-auditor` subagent it runs is `dot_config/claude/agents/eval-auditor.md`.
