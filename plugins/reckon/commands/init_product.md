---
description: Capture foundational product decisions through codebase scanning and user interview
---

# Initialize Product Decision Records

Capture the foundational product decisions that drive this repository's technical choices. Product decisions answer "what" and "why" — they define the target user, value proposition, feature boundaries, and business rules that technical decisions implement.

## Process

1. **Check existing records** — Call `mcp__reckon__list_decisions` to see what's already captured, especially existing product decisions. Note which areas already have product context.

2. **Scan for product signals** — Launch the `decision-scanner` agent with an explicit focus on product decisions. The agent should look for:
   - `README.md` — value proposition, target audience, feature scope
   - Landing pages / marketing copy — what the product claims to do (and doesn't)
   - Auth/access setup — who can use it, user persona assumptions
   - `CLAUDE.md` / `CONTRIBUTING.md` — workflow and process decisions
   - Feature flags, onboarding flows — user journey assumptions
   - The *absence* of features — what was deliberately not built

   For each signal, the agent should ask: "What product choice does this imply?"

3. **Interview the user** — The codebase can't fully answer product questions. Ask:
   - "Who is the primary user of this product? Not the role — describe the person."
   - "What is the single most important problem this product solves?"
   - "What did you deliberately choose NOT to build, and why?"
   - "What would make you deprecate or shut down this product?"

   If $ARGUMENTS specifies a focus area, tailor questions to that area.

4. **Propose a dependency tree** — Combine scanner findings and interview answers into a tree of product decisions. The tree should flow from strategic root decisions down to more specific product choices:
   ```
   Proposed Product Decisions:
   ├── [Core value proposition / target user]
   │   ├── [Feature boundary decision]
   │   └── [Access/auth scope decision]
   ├── [Business rule / workflow decision]
   │   └── [UX/behavior choice that follows from it]
   └── [Anti-decision: what we chose NOT to do]
   ```
   For each decision: title, tags, and a one-line summary.

   Where product decisions clearly drive existing technical decisions, note the connection:
   ```
   ├── GitHub-only authentication (product)
   │   └── drives: ADR-011 GitHub App, ADR-007 OAuth 2.1
   ```

5. **User reviews the tree** — Ask the user to review and adjust:
   - Accept, modify, remove, or add decisions
   - Confirm or change parent/child relationships
   - Confirm connections to existing technical decisions

6. **Batch capture** — After approval:
   - Call `mcp__reckon__capture_decision` for each decision with:
     - `source: "init"`
     - `sourceRef: "codebase-scan"`
     - `status: "proposed"`
     - `category: "product"`
     - Appropriate tags
   - Create dependency links matching the approved tree using `mcp__reckon__link_decisions`
   - Link product decisions to existing technical decisions they drive

7. **Present summary** — Show the final captured tree with ADR numbers, including links to existing technical decisions.
