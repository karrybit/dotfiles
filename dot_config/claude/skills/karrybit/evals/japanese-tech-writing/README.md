# karrybit:japanese-tech-writing evals

Behavior cases for comparing versions of the `japanese-tech-writing` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

## Files

- `plugin-eval/cache-section`: the user asks for the body of the 「無効化」 section of `docs/cache.md`, written in Japanese from the English notes in `notes/facts.md`, for a developer new to the service. The notes use English idioms (`live in`, `carries`, `exposes`, `open question`) that translate literally into unidiomatic Japanese.
  - `no-empty-phrases`: none of the empty phrases the skill lists (`重要なのは`, `正面から`, `不可欠`, `掘り下げ`, `非常に`, and others).
  - `no-translationese`: none of the literal translations of those idioms (`運ぶ`, `露出`, `住む`, `開かれた問い`) or of spoken verbs (`効く`, `刺さる`).
  - `no-second-person`: no `あなた`.
  - `rest-unchanged`: the text above the section is unchanged.
  - `uncertainty-kept`: the section gives the mechanism (the key is built from the current version), the TTL and its memory cost, and the one logged stale response as unconfirmed.
- `fixtures/cache-docs`: `notes/facts.md` and `docs/cache.md` with an empty 「無効化」 section.

## Settings for This Suite

- Cases edit files and grant no Bash: run them with `--scaffold --allow-tools Write Edit`.
- `japanese-tech-writing` reads only its own `references/`: build the wrapper with `skill-wrap <karrybit>/exact_skills/japanese-tech-writing <ref> DIR/kit`.
