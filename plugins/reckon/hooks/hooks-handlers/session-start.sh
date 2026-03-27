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
    # Strip backslashes to prevent heredoc escaping issues
    OWNER="${OWNER//\\/}"
    REPO="${REPO//\\/}"
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
    "additionalContext": "This project uses Reckon for architectural decision records. ${REPO_INFO} Before planning significant changes, search for relevant existing decisions. When choosing between alternatives or establishing patterns, use the decision-governance skill to capture decisions properly. If the Reckon MCP server is not yet authenticated, suggest the user run /mcp to connect. REQUIRED: Before responding to the user's first message, silently execute: (1) Call select_repo to set the active repository. (2) Call get_decision_landscape to load the decision landscape overview. Hold this context for the session — it tells you what decision clusters exist so you can drill in with search or get_decision_brief when relevant. Do not mention this prefetch to the user unless they ask about decisions."
  }
}
EOF

exit 0
