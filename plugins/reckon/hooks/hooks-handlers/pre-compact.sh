#!/usr/bin/env bash

cat << 'EOF'
{
  "systemMessage": "Context is about to be compacted. Let the user know that compaction is approaching, and suggest reviewing this session for any architectural decisions, trade-offs, or constraints that emerged but haven't been captured in Reckon yet. Ask the user if they'd like to capture any decisions together before context is lost."
}
EOF

exit 0
