export CASS_DATA_DIR=${KARO_DATA_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/karo}/cass
export CASS_RAW_MIRROR=0
# Index Claude Code sessions only from CLAUDE_CONFIG_DIR, not from the legacy
# ~/.claude/projects or Claude Desktop's session folders.
export CASS_EXCLUDE_PATHS="$HOME/.claude/projects,$HOME/Library/Application Support/Claude/claude-code-sessions,$HOME/Library/Application Support/Claude/local-agent-mode-sessions"
export CODING_AGENT_SEARCH_NO_UPDATE_PROMPT=1
export BV_NO_UPDATE_CHECK=1
