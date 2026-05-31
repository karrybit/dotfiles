#!/bin/bash

input=$(cat)

# Detect git branch or worktree name
if git rev-parse --git-dir >/dev/null 2>&1; then
  git_dir=$(git rev-parse --git-dir 2>/dev/null)
  if [[ "$git_dir" == *".git/worktrees/"* ]]; then
    worktree_name=$(basename "$(git rev-parse --show-toplevel)")
    branch_info="🌵 $worktree_name"
  else
    branch=$(git branch --show-current 2>/dev/null)
    branch_info="🌵 ${branch:-(detached)}"
  fi
else
  branch_info="🌵 (no git)"
fi

rest=$(echo "$input" | jq -r '[
  "🧠 " + (.model.display_name // "Claude"),
  "📊 " + ((.context_window.used_percentage // 0) | tostring) + "%",
  "💰 $" + ((.cost.total_cost_usd // 0) * 100 | round / 100 | tostring),
  "⚡ " + ((.rate_limits.five_hour.used_percentage // 0) | round | tostring) + "%"
] | join(" | ")')

echo "$rest | $branch_info"
