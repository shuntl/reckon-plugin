# Conflict Patterns and Resolution

## Common Conflict Types

### Technology Replacement

A new decision proposes replacing a technology that an existing decision adopted.

**Example:** Decision #1 adopts Vitest. A new proposal suggests switching to Jest.

**Resolution:**
- Surface the original decision's reasoning — it likely addressed specific constraints
- Ask if those constraints have changed
- If proceeding: supersede the old decision with full context on why the change is warranted

### Convention Contradiction

A new pattern conflicts with an established convention.

**Example:** Decision #5 establishes "all API routes return JSON errors". New code returns HTML error pages for a specific route.

**Resolution:**
- Determine if this is an exception or a replacement
- If exception: document the carve-out in a new decision that depends on #5
- If replacement: supersede #5 with the new convention

### Scope Expansion

A decision extends beyond the original scope of another, creating overlap or conflict.

**Example:** Decision #3 covers database access patterns. A new decision about caching implicitly changes database access patterns too.

**Resolution:**
- Create the new decision with an explicit dependency link to #3
- Note in the body how the scope relates: "This decision extends #3 by adding a caching layer in front of the patterns it established"

### Implicit Contradiction

Two decisions don't directly conflict but their combined implications create tension.

**Example:** Decision #2 prioritizes simplicity. Decision #7 adds a complex abstraction layer.

**Resolution:**
- Surface both decisions when the tension is noticed
- Ask the user whether the abstraction is justified despite the simplicity principle
- If yes: capture a new decision explaining the exception, linked to both

## Resolution Strategies

1. **Supersede** — Replace the old decision entirely. Use `mcp__reckon__update_decision` to create a new version. The old decision becomes frozen history.

2. **Scope-limit** — Keep both decisions but clarify their boundaries. Create a dependency link and update bodies to reference each other.

3. **Coexist with boundary** — Both decisions remain valid in different contexts. Document the boundary explicitly in a new decision that depends on both.

## When to Escalate

Always surface conflicts to the user. Never resolve a conflict autonomously by:
- Silently superseding an accepted decision
- Ignoring a contradiction and proceeding
- Creating a decision that contradicts another without acknowledgment
