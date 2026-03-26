---
description: Audit all decisions for staleness, conflicts, and missing links
argument-hint: "[optional: tag or category filter e.g. 'database', 'product']"
---

# Review Decision Records

Audit all active decisions for staleness, conflicts, and missing dependency links.

## Process

1. **Load decisions** — Call `mcp__reckon__list_decisions`. If $ARGUMENTS specifies a filter, pass it as a `tags` or `category` filter.

2. **Launch conflict checker** — Launch the `conflict-checker` agent with the full decision list as context.

3. **Present findings** — Organize the agent's results into three sections:

   ### Stale Decisions
   Decisions older than 90 days where the related code has changed significantly. For each, suggest: update, deprecate, or confirm still valid.

   ### Conflicts
   Pairs of decisions that contradict each other. For each, show both decisions and explain the contradiction. Suggest: supersede one, scope-limit, or coexist with explicit boundary.

   ### Missing Links
   Decisions that reference each other's topics but lack formal dependency links. For each, suggest creating the link with `mcp__reckon__link_decisions`.

4. **Act on user choices** — For each issue the user wants to resolve:
   - Stale: call `mcp__reckon__set_decision_status` to deprecate, or `mcp__reckon__update_decision` to refresh
   - Conflicts: follow the conflict resolution flow from the decision-governance skill
   - Missing links: call `mcp__reckon__link_decisions`
