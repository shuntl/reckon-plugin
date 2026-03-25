#!/usr/bin/env bash

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "This project uses Reckon for architectural decision records. Before planning significant changes, search for relevant existing decisions with mcp__reckon__search. When choosing between alternatives or establishing patterns, use the decision-governance skill to capture decisions properly."
  }
}
EOF

exit 0
