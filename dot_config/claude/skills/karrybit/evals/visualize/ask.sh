#!/usr/bin/env bash
# Usage: bash ask.sh <dir> <prompt-file> <schema-file> <model> <max-budget-usd>
# Runs one claude -p in <dir> whose only tool is Read, confined to <dir>, with
# no MCP server and no user settings, so it sees nothing but the files in <dir>.
# Writes <dir>/log.jsonl and <dir>/out.json (the structured output) and prints
# the reported cost, the number of Read calls, and the number of denied calls.
set -euo pipefail
[ $# -eq 5 ] || { echo "usage: ask.sh <dir> <prompt-file> <schema-file> <model> <max-budget-usd>" >&2; exit 2; }
dir=$(cd "$1" && pwd)
prompt=$(cd "$(dirname "$2")" && pwd)/$(basename "$2")
schema=$(cd "$(dirname "$3")" && pwd)/$(basename "$3")
cd "$dir"
claude -p --restricted --strict-mcp-config --tools Read --no-session-persistence \
  --model "$4" --max-budget-usd "$5" --json-schema "$(cat "$schema")" \
  --output-format stream-json --verbose < "$prompt" > log.jsonl
jq -c 'select(.type == "result") | .structured_output' log.jsonl > out.json
jq -s '(map(select(.type == "result"))[0]) as $r | {
  cost_usd: $r.total_cost_usd,
  reads: [.[] | select(.type == "assistant") | .message.content[]? | select(.type == "tool_use" and .name == "Read")] | length,
  denials: ($r.permission_denials | length)
}' log.jsonl
