#!/usr/bin/env bash

cat << 'EOF'
{
  "systemMessage": "This project uses Reckon for architectural decision governance. Before making implementation choices, search for relevant decisions using mcp__reckon__search. Existing decisions may constrain your approach. Call mcp__reckon__get_decision_landscape for an overview of recorded decision areas."
}
EOF

exit 0
