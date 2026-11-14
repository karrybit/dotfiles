# Skill Design

Read when: creating, splitting, or combining skills, or deciding where a skill,
a subagent, or a script or reference file they use lives. How to word their
lines is in `instruction-writing-standard.md` beside this file; whether to add
a skill at all is in `instruction-maintenance.md`.

## Boundaries

- Write each skill as a deep module that knows no other skill: describe what it
  needs from outside as an input contract instead of naming the skill that
  produces it.
- When a skill exists to use one specific skill well, name that skill; this is
  the only exception to the rule above.
- When a task needs several skills combined, put the combination in a separate
  orchestrator skill, leave the combined skills unaware of it, and keep them
  separate instead of merging them.
- When the same combination serves several callers, make the orchestrator
  general too, so a system-specific layer only picks general skills and passes
  them values.
- When a system routes among many skills, map each of its states to the skill
  to use in one table in that system's instruction file, instead of having the
  skills name each other.
- When one skill mixes driving a general tool with operating one system, split
  it: the general skill drives the tool, and the system's skill uses it.
- When one skill holds both sides of a hand-off (writing a report and acting on
  it), split off the side that does not depend on the receiving system.
- When a skill seems tied to a system, narrow it to what it does and leave
  where and in which session it runs to the caller; the tie often goes away.
- When dropping another skill's name from a `description` to meet these rules,
  compare rewordings with Small Evaluation in `instruction-writing-standard.md`
  before keeping one, since the name may be what triggered the skill.

## Values From the Caller

- Take values that belong to a system, repository, person, or machine (output
  paths, project terms, a check's schema, the files to check) as arguments or a
  file the caller passes, so a general skill holds no company names, local
  paths, or personal records.
- When one script mixes a general check with a system-specific one, move the
  general part beside its skill, and keep the specific part with the system or
  pass it in as configuration.
- Keep a part inside its only user when generalizing it would make its inputs
  as wide as its body (when, say, the shape of what it counts is that project's
  own convention), and split it out when a second user appears.

## Scripts

- Put deterministic work in a script, and keep only the steps and the call in
  `SKILL.md`.
- When a skill runs a script that the caller's settings must allow or exclude
  from the sandbox, write the `~/` path it is deployed to instead of
  `${CLAUDE_SKILL_DIR}`, since permission rules and `sandbox.excludedCommands`
  match the command text as written (`crit-open` in the `crit` skill); call
  any other script there as `${CLAUDE_SKILL_DIR}/scripts/<name>`.
- Give a skill a name that no other skill or script shares, including the
  scripts that will move into its `scripts/`.

## Placement

- Put a script or reference file that one skill uses in that skill's folder,
  scripts in `scripts/`; keep under `~/.local/share/agents/` what `CLAUDE.md`,
  settings, hooks, other documents, or more than one skill use.
- Put a skill used in every repository in the user-scope skills, since a
  repository's `.claude/skills/` loads only in that repository, and keep its
  steps in `SKILL.md`, since the other files in its folder load only when
  `SKILL.md` points to them.
- Keep skills that have a single user as a plugin in the user's skills
  directory, and give them a marketplace repository when a second user
  appears; the official docs name `--plugin-dir` or the skills directory for a
  plugin used only by its author.
- Put skills specific to one system in a plugin or project skills directory of
  their own, beside the general plugin, since a plugin name cannot contain `:`
  and so plugins cannot nest.
- Put a subagent called by name (`--agent <name>`) in an agents directory even
  when one skill is its only caller, since one kept in the skill's folder must
  be passed as `--agents` JSON at every call.
- Keep a skill's tests and eval data in the repository that holds the skill:
  script tests in its `scripts/`, and `claude plugin eval` cases in the
  plugin's `evals/<skill>/`, since `--eval-dir` refuses a directory inside
  `skills/`.
- After moving or renaming a skill, search every instruction file, skill, and
  subagent that can name it, including those outside the repository, for the
  old name, and update each one.
