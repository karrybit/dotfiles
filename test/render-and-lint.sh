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

for profile in work private_neo private_minipc; do
    tmpconfig="$TMPDIR/chezmoi-lint-${profile}.toml"
    printf '[data]\n    name = "karrybit"\n    profile = "%s"\n' "$profile" > "$tmpconfig"

    for tmpl in "${tmpls[@]}"; do
        target="$(chezmoi target-path "$tmpl")"
        rendered="$(chezmoi --config "$tmpconfig" --source "$source_dir" cat "$target" 2>&1)"
        lint_string "${tmpl#$source_dir/} [${profile}]" "$rendered"
    done
done

# ── macOS shell dependencies ──────────────────────────────────────────────────
printf "\n\e[1mmacOS shell dependencies\e[0m\n"

for profile in work private_neo; do
    brewfile="$source_dir/dot_config/homebrew/Brewfile.$profile"
    for tool in direnv starship; do
        if rg -Fqx "brew \"$tool\"" "$brewfile"; then
            ok "Brewfile.$profile installs $tool used by dot_zshrc"
        else
            fail "Brewfile.$profile installs $tool used by dot_zshrc"
        fi
    done
done

work_only_actual="$(
    comm -23 \
        <(rg -o '^brew "[^"]+"' "$source_dir/dot_config/homebrew/Brewfile.work" | LC_ALL=C sort) \
        <(rg -o '^brew "[^"]+"' "$source_dir/dot_config/homebrew/Brewfile.private_neo" | LC_ALL=C sort)
)"
work_only_expected='brew "air"
brew "buf"
brew "cargo-make"
brew "dbmate"
brew "gofumpt"
brew "golang-migrate"
brew "helm"
brew "k6"
brew "kind"
brew "kubectx"
brew "kubernetes-cli"
brew "kustomize"
brew "lcov"
brew "poppler"
brew "protobuf"
brew "sccache"
brew "skaffold"
brew "tbls"
brew "wasm-pack"'
if [[ "$work_only_actual" == "$work_only_expected" ]]; then
    ok "private_neo contains the shared macOS formula baseline"
else
    fail "private_neo contains the shared macOS formula baseline"
fi

# ── Codex partial config ──────────────────────────────────────────────────────
printf "\n\e[1mCodex partial config\e[0m\n"

codex_fixture='model = "old-model"
future_setting = "preserve-me"

[projects."/example/project"]
trust_level = "trusted"

[tui.model_availability_nux]
old-model = 7'

codex_rendered="$(
    print -r -- "$codex_fixture" |
        chezmoi execute-template --with-stdin \
            --file "$source_dir/dot_codex/modify_private_config.toml"
)"
codex_json="$(
    print -r -- "$codex_rendered" |
        chezmoi execute-template --with-stdin \
            '{{ .chezmoi.stdin | fromToml | toJson }}'
)"

if print -r -- "$codex_json" | jq -e '
    .model == "gpt-5.6-sol" and
    .model_reasoning_effort == "medium" and
    .approvals_reviewer == "auto_review" and
    .future_setting == "preserve-me" and
    .projects["/example/project"].trust_level == "trusted" and
    .tui.model_availability_nux["old-model"] == 7 and
    .tui.status_line == ["model", "current-dir", "five-hour-limit", "context-used", "used-tokens"] and
    .plugins["github@openai-curated"].enabled == true and
    .plugins["google-drive@openai-curated"].enabled == true and
    .features.memories == true
' >/dev/null; then
    ok "dot_codex/modify_private_config.toml passes through local Codex state"
else
    fail "dot_codex/modify_private_config.toml passes through local Codex state"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
printf "\n%d passed, %d failed\n" "$pass" "$fail"
(( fail == 0 ))
