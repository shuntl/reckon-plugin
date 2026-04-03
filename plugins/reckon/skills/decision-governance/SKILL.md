---
name: decision-governance
description: >-
  This skill should be used when the user asks to "capture a decision",
  "record an architecture choice", "document why we chose X", "capture a process",
  "document how to", "record a workflow", or when choosing between implementation
  alternatives, establishing new patterns, making trade-offs, planning significant
  architectural changes, evaluating technology options, questioning why something was
  done a certain way, or documenting processes, runbooks, and how-tos.
  Also use when entering plan mode for non-trivial work that involves
  architectural choices.
---

# Decision & Process Governance via Reckon

Govern architectural decisions, product decisions, and processes through Reckon MCP tools. Every significant choice or repeatable procedure should be searched, evaluated against existing records, and captured when new.

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

After searching, if the new decision contradicts, refines, or replaces an existing `accepted` or `proposed` decision:

1. Surface the overlap immediately — show the existing decision's number, title, and key reasoning
2. Explain how the new decision relates: is it a contradiction, a refinement, a narrowing of scope, or a full replacement?
3. Ask the user to choose: **supersede** the old decision via `mcp__reckon__supersede_decision` (creates a new version, marks the old one inactive), **adjust** the current approach to coexist, or **proceed with both** (with explicit justification for why they are distinct)
4. Never silently create a standalone decision that should be a new version of an existing one

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

**Refinement check:** Before calling `capture_decision`, review search results for an existing decision covering the same topic. If the new decision refines, narrows, or replaces an existing one, call `mcp__reckon__supersede_decision` instead — this marks the old version inactive and creates a new version that inherits its links and signals.

Structure the body using the template in `references/decision-template.md`.

## Link Carry-Forward

When superseding a decision via `mcp__reckon__supersede_decision`, all dependency links are automatically cloned to the new version. The response includes `_clonedLinks` showing how many were carried forward. Redundant transitive links are automatically removed during cloning. After superseding:

1. Review the cloned links — are they all still relevant to the updated decision?
2. Use `mcp__reckon__unlink_decisions` to remove any that no longer apply
3. Links are preserved by default to prevent accidental data loss

## Transitive Reduction

The system enforces transitive reduction on all dependency links. When creating links:

- **Link to the most specific relevant decision, not ancestors.** If A depends on B and B depends on C, do NOT also link A to C — the system will silently skip the redundant link.
- When adding a new link that makes an existing link redundant, the system automatically removes the redundant one.
- Use `mcp__reckon__reduce_graph` to clean up any accumulated redundancies across the entire graph.

## Quality Bar

**Capture** if:
- Hard to reverse
- Someone would reasonably ask "why did we do it this way?"
- Constrains future choices

**Skip** if:
- Variable naming, code formatting, trivial implementation details
- One-off debugging steps
- Choices with no meaningful alternatives

## Signal Capture Protocol

Signals are lightweight evidence attached to decisions. Capture a signal when:
- A user shares evidence that supports or contradicts a decision (customer quote, metric, anecdote)
- A meeting produces observations relevant to an existing decision
- Code changes reveal that an assumption behind a decision was wrong or right
- Analytics or user research data relates to an existing decision

When capturing via `mcp__reckon__capture_signal`:
- `body`: The evidence itself, stated factually. Include direct quotes when possible.
- `source`: Evidence type — `"customer-call"`, `"meeting-transcript"`, `"metrics"`, `"code-review"`, `"support-ticket"`, `"user-research"`
- `sourceRef`: Link to the source if available (meeting notes URL, ticket link, dashboard URL)

Signals are append-only and zero-friction. **Prefer capturing too many signals over too few.** The body is the only required field.

### Hypothesis-Evidence Assessment

Product decisions in `draft` or `proposed` status are **hypotheses** — beliefs being acted on that could be validated or invalidated.

After capturing signals on a hypothesis:
- Briefly assess the evidence balance: _"3 signals support this hypothesis, 1 contradicts it"_
- If contradicting signals accumulate, proactively ask: _"This hypothesis has growing counter-evidence. Should we reconsider?"_
- When a hypothesis has strong supporting evidence, suggest promotion: _"This hypothesis has 5 supporting signals. Consider accepting it as a validated decision."_

## Status Lifecycle

- `draft` — Captured during work, not yet discussed with stakeholders. Default for agent-captured decisions.
- `proposed` — Ready for review. Set when the user explicitly asks to propose.
- `accepted` — Approved and in effect. Only set when the user explicitly confirms.
- `under_review` — Being reconsidered. Set when questioning an existing decision.
- `deprecated` / `rejected` — No longer active.

Product decisions in `draft` or `proposed` status are presented as **hypotheses** — they represent beliefs to be validated with signal evidence. When accepted, they become **validated decisions**. The `proposed` → `accepted` transition gains real meaning when backed by accumulated signals.

**Superseded decisions are frozen history** — they have no meaningful status and cannot be updated. Signals are automatically carried forward to the new version when a decision is superseded.

## Tags Convention

Use lowercase tags for topic classification (not type — that's what `category` is for):

`architecture`, `database`, `testing`, `auth`, `frontend`, `infrastructure`, `tooling`, `api`, `security`, `performance`, `conventions`, `bugfix`

## Process Governance

Processes are documented procedures, workflows, and how-tos. They live alongside decisions in the same graph and can link to decisions they depend on or implement.

### Decision vs Process

- **Decision**: A choice that was made — "We use PostgreSQL", "Auth via GitHub OAuth only"
- **Process**: A documented procedure — "How to deploy to production", "PR review checklist", "Database migration workflow"

### Process Capture Protocol

Capture a process when:
- The user describes a repeatable workflow or procedure
- A new team member would need these steps documented
- The procedure involves multiple steps that could be forgotten
- The workflow implements or follows one or more decisions

When capturing via `mcp__reckon__capture_process`:
- `category`: `"technical"` for development/ops processes, `"product"` for product/business processes
- `source`: `"claude-code"`
- `status`: `"draft"` (default)
- `linkedRecordIds`: IDs of decisions or other processes this process depends on
- `metadata.paths`: file paths most relevant to this process

Structure the body with clear steps:
```
## Purpose
Why this process exists and when to use it.

## Prerequisites
What must be in place before starting.

## Steps
1. First step...
2. Second step...
3. Third step...

## Notes
Edge cases, common mistakes, tips.
```

### Process Supersede

When a process's steps change, use `mcp__reckon__supersede_process` to create a new version. The old version is preserved as history. Signals (feedback, exceptions) are carried forward automatically.

### Process Search

Before capturing a new process, search for existing ones:
1. Call `mcp__reckon__search` with relevant keywords
2. If an existing process covers the same workflow, supersede it instead of creating a duplicate
3. Processes can link to decisions via the dependency system — a deployment process might depend on the "Deploy via Railway" decision

### Process Signals

Signals on processes capture:
- Feedback about steps that were confusing or wrong
- Exceptions or edge cases encountered
- Observed improvements or shortcuts
- Evidence that the process needs updating

## Additional Resources

- **`references/decision-template.md`** — Full decision body template with field descriptions
- **`references/conflict-patterns.md`** — Common conflict patterns and resolution strategies
