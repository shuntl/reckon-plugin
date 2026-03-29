#!/usr/bin/env bash

INPUT=$(cat)

# Extract session_id — simple grep, no jq dependency
SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"session_id"[[:space:]]*:[[:space:]]*"//;s/"//')
SESSION_ID="${SESSION_ID:-default}"

# Extract command from tool_input
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"command"[[:space:]]*:[[:space:]]*"//;s/"//')

[ -z "$COMMAND" ] && exit 0

# Match only high-signal commands that imply architectural choices
PATTERN_KEY=""
case "$COMMAND" in
  *"npm install "*|*"pnpm add "*|*"yarn add "*)
    PATTERN_KEY="dependency-add"
    ;;
  *"pip install "*|*"pip3 install "*|*"uv add "*|*"uv pip install "*|*"poetry add "*|*"pipenv install "*)
    PATTERN_KEY="dependency-add"
    ;;
  *"cargo add "*|*"go get "*|*"gem install "*|*"composer require "*|*"brew install "*)
    PATTERN_KEY="dependency-add"
    ;;
  *"npx create-"*|*"npm init "*)
    PATTERN_KEY="project-scaffold"
    ;;
  *docker*|*terraform*|*pulumi*|*"kubectl apply"*)
    PATTERN_KEY="infrastructure"
    ;;
  *"prisma migrate"*|*"drizzle-kit"*|*"knex migrate"*|*alembic*|*"django migrate"*)
    PATTERN_KEY="database-migration"
    ;;
  *railway*|*vercel*|*netlify*|*"fly deploy"*|*"aws "*|*"gcloud "*|*"az "*)
    PATTERN_KEY="deployment"
    ;;
esac

[ -z "$PATTERN_KEY" ] && exit 0

# Dedup: one reminder per category per session
STATE_FILE="${TMPDIR:-/tmp}/reckon-reminded-bash-${SESSION_ID}"

if [ -f "$STATE_FILE" ] && grep -qF "$PATTERN_KEY" "$STATE_FILE"; then
  exit 0
fi

echo "$PATTERN_KEY" >> "$STATE_FILE"

# Probabilistic cleanup of old state files (10% chance)
if [ $((RANDOM % 10)) -eq 0 ]; then
  find "${TMPDIR:-/tmp}" -name "reckon-reminded-*" -mtime +1 -delete 2>/dev/null
fi

cat << 'EOF'
{
  "systemMessage": "This command may establish or change infrastructure/dependencies. Search Reckon for existing decisions about this area (use mcp__reckon__search). If this introduces a new technology choice, consider capturing a decision afterward with the decision-governance skill."
}
EOF

exit 0
