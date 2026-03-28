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

### Enable auto-updates

Reckon is actively developed. To get plugin updates automatically, enable auto-update for the marketplace:

1. Run `/plugin` to open the plugin manager
2. Go to the **Marketplaces** tab
3. Find `reckon-plugins` and enable auto-update

Without auto-update, you can manually update anytime:

```bash
/plugin update reckon@reckon-plugins
```

After updating, run `/reload-plugins` to load the new version into your current session.

## Quickstart

The fastest way to bootstrap decision records for your project:

1. **Enter plan mode** — type `/plan` so Claude researches your codebase without making changes
2. **Run `/reckon:init_product`** — scans for product decisions (scope, users, business rules) and interviews you about value proposition, target users, and feature boundaries. Review and approve the proposed decision tree.
3. **Enter plan mode again** — type `/plan` for the next scan
4. **Run `/reckon:init_technical`** — scans for implicit technical decisions (frameworks, architecture, tooling) and interviews you about constraints. Links to the product decisions captured in step 2. Review and approve.

After both scans, you'll have a full decision landscape with dependency links between technical and product choices.

You can also run `/reckon:init` to execute both scans in sequence.

## What It Does

### Automatic (always active)

- **Session awareness** — On every session start, a lightweight hook reminds Claude to check existing decisions before planning significant work.
- **Decision governance skill** — Auto-loads when Claude detects decision-making activity (choosing alternatives, establishing patterns, making trade-offs). Guides Claude through search, conflict detection, and structured capture.

### Commands

| Command | Description |
|---------|-------------|
| `/reckon:init` | Run both product and technical init in sequence |
| `/reckon:init_product` | Capture foundational product decisions through scanning and interview |
| `/reckon:init_technical` | Scan codebase for implicit technical decisions and bootstrap records |
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
