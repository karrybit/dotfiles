#!/usr/bin/env bash
set -u

errors=0
warnings=0
skills=0
tmp_names=$(mktemp)
trap 'rm -f "$tmp_names"' EXIT

error() {
    printf 'ERROR: %s\n' "$*" >&2
    errors=$((errors + 1))
}

warn() {
    printf 'WARN: %s\n' "$*" >&2
    warnings=$((warnings + 1))
}

audit_skill() {
    local skill_dir=$1
    local skill_file="$skill_dir/SKILL.md"
    local dir_name
    local frontmatter
    local name
    local description
    local lines

    skills=$((skills + 1))
    dir_name=$(basename "$skill_dir")
    frontmatter=$(
        awk '
            NR == 1 {
                if ($0 != "---") exit
                next
            }
            $0 == "---" { exit }
            { print }
        ' "$skill_file"
    )
    name=$(printf '%s\n' "$frontmatter" | sed -n 's/^name:[[:space:]]*["'\'']\{0,1\}\([^"'\'']*\)["'\'']\{0,1\}[[:space:]]*$/\1/p' | head -1)
    description=$(printf '%s\n' "$frontmatter" | sed -n 's/^description:[[:space:]]*//p' | head -1)

    if [[ -z "$name" ]]; then
        error "$skill_file: missing frontmatter name"
    elif [[ "$name" != "$dir_name" ]]; then
        error "$skill_file: name '$name' does not match directory '$dir_name'"
    else
        printf '%s\t%s\n' "$name" "$skill_file" >> "$tmp_names"
    fi

    [[ -n "$description" ]] || error "$skill_file: missing frontmatter description"
    [[ -f "$skill_dir/agents/openai.yaml" ]] || warn "$skill_dir: missing recommended agents/openai.yaml"

    lines=$(wc -l < "$skill_file" | tr -d ' ')
    (( lines <= 500 )) || warn "$skill_file: $lines lines; consider progressive disclosure"

    if command -v rg >/dev/null 2>&1; then
        rg -n 'TODO|\[TODO' "$skill_file" >/dev/null 2>&1 &&
            warn "$skill_file: contains TODO markers"
    elif grep -n -E 'TODO|\[TODO' "$skill_file" >/dev/null 2>&1; then
        warn "$skill_file: contains TODO markers"
    fi
}

if (( $# == 0 )); then
    set -- .agents/skills "$HOME/.agents/skills"
fi

for root in "$@"; do
    if [[ ! -d "$root" ]]; then
        warn "$root: skill root does not exist"
        continue
    fi

    while IFS= read -r skill_file; do
        audit_skill "$(dirname "$skill_file")"
    done < <(find "$root" -mindepth 2 -maxdepth 2 -name SKILL.md -type f | sort)
done

while IFS=$'\t' read -r count name; do
    (( count > 1 )) && error "duplicate skill name '$name' appears $count times"
done < <(cut -f1 "$tmp_names" | sort | uniq -c | awk '{ print $1 "\t" $2 }')

printf 'Audited %d skill(s): %d error(s), %d warning(s)\n' "$skills" "$errors" "$warnings"
(( errors == 0 ))
