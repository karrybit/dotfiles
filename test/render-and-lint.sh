#!/usr/bin/env zsh
# Render chezmoi templates for all 3 profiles and zsh -n lint everything.
set -uo pipefail

typeset -i pass=0 fail=0

source_dir="$(chezmoi source-path)"

ok()   { printf "  \e[32m✓\e[0m %s\n"    "$1"; (( pass++ )) }
fail() { printf "  \e[31m✗\e[0m %s\n"    "$1" >&2; (( fail++ )) }

lint_file() {
    local label="$1" file="$2"
    if zsh -n "$file" 2>/dev/null; then ok "$label"
    else
        fail "$label"
        zsh -n "$file" 2>&1 | sed 's/^/      /' >&2
    fi
}

lint_string() {
    local label="$1" content="$2"
    if print -r -- "$content" | zsh -n 2>/dev/null; then ok "$label"
    else
        fail "$label"
        print -r -- "$content" | zsh -n 2>&1 | sed 's/^/      /' >&2
    fi
}

# ── Static files ─────────────────────────────────────────────────────────────
printf "\n\e[1mStatic zsh files\e[0m\n"

# zsh named files (dot_zshrc, dot_zshenv)
for f in "$source_dir"/dot_config/zsh/dot_zsh{rc,env}(N); do
    lint_file "${f#$source_dir/}" "$f"
done

# .zsh files (excluding .tmpl)
while IFS= read -r f; do
    lint_file "${f#$source_dir/}" "$f"
done < <(find "$source_dir/dot_config/zsh" -name "*.zsh" ! -name "*.zsh.tmpl" | LC_ALL=C sort)

# functions and widgets (no extension, regular files)
while IFS= read -r f; do
    lint_file "${f#$source_dir/}" "$f"
done < <(find \
    "$source_dir/dot_config/zsh/functions" \
    "$source_dir/dot_config/zsh/widgets" \
    -maxdepth 2 -type f | LC_ALL=C sort)

# ── Template files (3 profiles) ──────────────────────────────────────────────
printf "\n\e[1mTemplate files\e[0m\n"

tmpls=("${(@f)$(find "$source_dir/dot_config/zsh" -name "*.tmpl" | LC_ALL=C sort)}")

for profile in work personal_neo personal_minipc; do
    tmpconfig="$TMPDIR/chezmoi-lint-${profile}.toml"
    printf '[data]\n    name = "karrybit"\n    profile = "%s"\n' "$profile" > "$tmpconfig"

    for tmpl in "${tmpls[@]}"; do
        target="$(chezmoi target-path "$tmpl")"
        rendered="$(chezmoi --config "$tmpconfig" --source "$source_dir" cat "$target" 2>&1)"
        lint_string "${tmpl#$source_dir/} [${profile}]" "$rendered"
    done
done

# ── Summary ───────────────────────────────────────────────────────────────────
printf "\n%d passed, %d failed\n" "$pass" "$fail"
(( fail == 0 ))
