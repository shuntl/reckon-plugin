---
name: conflict-check-proposal
description: Check a single proposed decision for conflicts against the accepted decision graph. Triggered from the review queue "Check for conflicts" button or via /reckon-conflicts <decisionId>.
---

# Conflict Check — Single Proposal

This skill checks one proposed decision against all accepted decisions in the graph and surfaces potential conflicts.

## When to use

- Reviewer clicks "Check for conflicts" in the Reckon review queue or decision detail page
- User runs `/reckon-conflicts <decisionId>` in Claude
- User asks "does this decision conflict with anything?"

## Workflow

1. **Fetch the proposal** — call `mcp__reckon__get_decision` with the provided decision ID
2. **Fetch accepted decisions** — call `mcp__reckon__list_decisions` with `status=accepted` and `limit=100`
3. **Analyze for conflicts** using the patterns in `references/conflict-patterns.md`:
   - **Direct contradictions** — the proposal takes an opposing position to an accepted decision on the same topic
   - **Scope overlaps** — two decisions govern the same domain/area but prescribe different approaches
   - **Dependency gaps** — the proposal depends on something that isn't yet accepted or doesn't exist
   - **Supersession candidates** — an accepted decision covers the same ground and should be deprecated if this proposal is accepted
4. **Present findings conversationally** — reference specific decision IDs (DR-XXX) and explain the nature of each conflict
5. **Allow follow-up questions** — the reviewer may ask for more detail on a specific conflict or ask you to compare specific decisions

## Output format

For each conflict found:
- Name the conflicting accepted decision (DR-XXX: title)
- Explain the nature of the conflict (contradiction, overlap, gap, or supersession)
- Suggest resolution (amend the proposal, supersede the existing decision, or add a dependency link)

If no conflicts are found, say so clearly — "No conflicts detected against the current accepted graph."

## Distinct from /reckon:review

The `/reckon:review` command runs a full graph analysis (all decisions, all tensions, all gaps). This skill is scoped to **one proposal vs the rest** — faster, cheaper, and focused on the reviewer's immediate question.
