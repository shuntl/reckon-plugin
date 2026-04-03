#!/usr/bin/env bash

cat << 'EOF'
{
  "systemMessage": "You are entering plan mode. Before designing your approach, search Reckon for existing decisions and processes that may constrain or inform your plan. Use mcp__reckon__search with keywords relevant to the task. Check for decisions about the technologies, patterns, and areas you're planning to change. Also check for relevant processes (workflows, how-tos) that document established procedures. Reference any relevant decisions or processes in your plan and flag potential conflicts."
}
EOF

exit 0
