# Reckon — Decision Governance Plugin for Claude Code

Automatically capture, search, and govern architectural decisions during development.

## Prerequisites

A Reckon MCP server must be configured and connected to your Claude Code session. See [reckon.sh](https://reckon.sh) for setup instructions.

## Installation

```bash
# Add the marketplace
/plugin marketplace add shuntl/reckon-plugin

# Install the plugin
/plugin install reckon
```

## What It Does

### Automatic (always active)

- **Session awareness** — On every session start, a lightweight hook reminds Claude to check existing decisions before planning significant work.
- **Decision governance skill** — Auto-loads when Claude detects decision-making activity (choosing alternatives, establishing patterns, making trade-offs). Guides Claude through search, conflict detection, and structured capture.

### Commands

| Command | Description |
|---------|-------------|
| `/reckon:init` | Scan codebase for implicit decisions and bootstrap Reckon records |
| `/reckon:review` | Audit all decisions for staleness, conflicts, and missing links |
| `/reckon:decisions` | Show a summary table of all active decisions |

## Decision Lifecycle

```
draft → proposed → accepted
                 → rejected
        ↓
    under_review → accepted / deprecated
```

- **draft** — Captured during work, not yet reviewed
- **proposed** — Ready for stakeholder review
- **accepted** — Approved and in effect
- **under_review** — Being reconsidered

Superseded decisions are frozen history with no active status.

## Decision Categories

Every decision is either **technical** or **product**:

- **Technical** — Frameworks, patterns, architecture, schema, API design, testing, infrastructure
- **Product** — Feature scope, user experience, business rules, access control, pricing

## How It Works

1. **Before planning** — Claude searches Reckon for existing decisions relevant to the task
2. **Conflict detection** — If the planned approach contradicts an existing decision, Claude surfaces it
3. **Capture** — When a decision is made, Claude captures it with full context, alternatives, and trade-offs
4. **Linking** — Related decisions are connected via dependency links
