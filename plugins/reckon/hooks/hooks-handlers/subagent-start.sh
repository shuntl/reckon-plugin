#!/usr/bin/env bash

cat << 'EOF'
{
  "systemMessage": "This project uses Reckon for architectural decision governance. Before making implementation choices, search for relevant decisions using mcp__reckon__search. Existing decisions may constrain your approach. If a new decision refines or replaces an existing one, call supersede_decision to create a new version rather than capturing a standalone duplicate. Call mcp__reckon__get_decision_landscape for an overview of recorded decision areas. When you encounter evidence that supports or contradicts an existing decision, capture it as a signal using capture_signal."
}
EOF

exit 0
