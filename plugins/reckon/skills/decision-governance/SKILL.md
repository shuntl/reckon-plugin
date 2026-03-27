---
name: decision-governance
description: >-
  This skill should be used when the user asks to "capture a decision",
  "record an architecture choice", "document why we chose X", or when
  choosing between implementation alternatives, establishing new patterns,
  making trade-offs, planning significant architectural changes, evaluating
  technology options, or questioning why something was done a certain way.
  Also use when entering plan mode for non-trivial work that involves
  architectural choices.
---

# Decision Governance via Reckon

Govern architectural and product decisions through Reckon MCP tools. Every significant choice — technical or product — should be searched, evaluated against existing decisions, and captured when new.

## Category: Technical vs Product

Every decision requires a `category` field:

- **`technical`** — Implementation choices: frameworks, patterns, architecture, schema design, API contracts, testing strategy, infrastructure, security, tooling. Capture when choosing technologies, establishing code conventions, making performance trade-offs, or fixing bugs with non-obvious root causes.
- **`product`** — Scope and behavior choices: feature boundaries, user experience, business rules, access control policies, pricing, integration strategy. Capture when defining what the product does or doesn't do, choosing between UX approaches, or establishing business rules.

## Search Protocol

Before planning any significant work, search for existing decisions:

1. Extract 2-3 keywords from the task at hand
2. Call `mcp__reckon__search` with those keywords
3. If the task involves specific files, also call `mcp__reckon__search_by_path` with those file paths to find decisions governing that code area
4. If results exist, call `mcp__reckon__get_decision` to read the full decision including dependency links
5. If a decision constrains the planned approach, state it explicitly: _"Existing decision #N establishes X. This constrains our approach."_
6. Use `mcp__reckon__list_decisions` with `category` or `tags` filters for broader context

## Conflict Detection

After searching, if the planned approach contradicts an existing `accepted` or `proposed` decision:

1. Surface the conflict immediately — show the existing decision's number, title, and key reasoning
2. Explain how the current plan conflicts
3. Ask the user to choose: **supersede** the old decision, **adjust** the current approach, or **proceed with both** (with explicit justification)
4. Never silently contradict an accepted decision

## Capture Protocol

Capture a decision when:
- Choosing between meaningful alternatives (frameworks, patterns, approaches)
- Establishing a new convention or pattern
- Making a trade-off (performance vs simplicity, consistency vs flexibility)
- Fixing a bug with a non-obvious root cause (the fix IS the decision)
- Defining a product boundary or business rule

When capturing, set:
- `category`: `"technical"` or `"product"`
- `source`: `"claude-code"`
- `sourceRef`: brief context string (e.g. `"auth-refactor-session"`)
- `status`: `"draft"` (default — never auto-set `accepted`)
- `linkedDecisionIds`: IDs of related decisions found during search
- `metadata.paths`: file paths most relevant to this decision (the files that would need to change if this decision were reversed)
- `metadata.pathPatterns`: glob patterns for broader coverage (e.g. `"packages/db/**"` for database decisions)

Structure the body using the template in `references/decision-template.md`.

## Link Carry-Forward

When superseding a decision via `mcp__reckon__update_decision`, all dependency links are automatically cloned to the new version. The response includes `_clonedLinks` showing how many were carried forward. After superseding:

1. Review the cloned links — are they all still relevant to the updated decision?
2. Use `mcp__reckon__unlink_decisions` to remove any that no longer apply
3. Links are preserved by default to prevent accidental data loss

## Quality Bar

**Capture** if:
- Hard to reverse
- Someone would reasonably ask "why did we do it this way?"
- Constrains future choices

**Skip** if:
- Variable naming, code formatting, trivial implementation details
- One-off debugging steps
- Choices with no meaningful alternatives

## Status Lifecycle

- `draft` — Captured during work, not yet discussed with stakeholders. Default for agent-captured decisions.
- `proposed` — Ready for review. Set when the user explicitly asks to propose.
- `accepted` — Approved and in effect. Only set when the user explicitly confirms.
- `under_review` — Being reconsidered. Set when questioning an existing decision.
- `deprecated` / `rejected` — No longer active.

**Superseded decisions are frozen history** — they have no meaningful status and cannot be updated.

## Tags Convention

Use lowercase tags for topic classification (not type — that's what `category` is for):

`architecture`, `database`, `testing`, `auth`, `frontend`, `infrastructure`, `tooling`, `api`, `security`, `performance`, `conventions`, `bugfix`

## Additional Resources

- **`references/decision-template.md`** — Full decision body template with field descriptions
- **`references/conflict-patterns.md`** — Common conflict patterns and resolution strategies
