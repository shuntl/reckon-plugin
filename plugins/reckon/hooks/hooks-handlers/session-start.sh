#!/usr/bin/env bash

# Auto-detect repo from git remote
REPO_INFO=""
if REMOTE_URL=$(git remote get-url origin 2>/dev/null); then
  # Parse github.com/owner/repo or github.com:owner/repo
  if [[ "$REMOTE_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    # Sanitize: strip anything that isn't alphanumeric, hyphen, dot, or underscore
    OWNER="${OWNER//[^a-zA-Z0-9._-]/}"
    REPO="${REPO//[^a-zA-Z0-9._-]/}"
    if [ -n "$OWNER" ] && [ -n "$REPO" ]; then
      REPO_INFO="Detected GitHub repo: ${OWNER}/${REPO}. Call select_repo with owner=\\\"${OWNER}\\\" and repo=\\\"${REPO}\\\" to set context before using other Reckon tools."
    fi
  fi
fi

if [ -z "$REPO_INFO" ]; then
  REPO_INFO="Not in a recognized GitHub repo. Call list_repos to see available repositories, then select_repo to set context."
fi

cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "This project uses Reckon for architectural decision records. ${REPO_INFO} Before planning significant changes, search for relevant existing decisions. When choosing between alternatives or establishing patterns, use the decision-governance skill to capture decisions properly. If the Reckon MCP server is not yet authenticated, suggest the user run /mcp to connect."
  }
}
EOF

exit 0
