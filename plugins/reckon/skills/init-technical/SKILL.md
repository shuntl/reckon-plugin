---
description: Scan codebase for implicit technical decisions and bootstrap Reckon records
argument-hint: "[optional: focus area e.g. 'database', 'auth', 'testing']"
---

# Initialize Technical Decision Records

Bootstrap this repository's technical decision records by scanning the codebase for implicit implementation, architecture, and tooling choices that have already been made but not recorded.

## Process

1. **Check existing records** — Call `mcp__reckon__list_decisions` to see what's already captured. Note existing decisions to avoid duplicates.

2. **Launch scanner** — Launch the `decision-scanner` agent to analyze the codebase with a focus on technical decisions. If $ARGUMENTS specifies a focus area, pass it to the agent.

3. **Interview the user** — Ask these questions to surface decisions the scanner can't infer from code alone:
   - "What technical constraints shaped this project? (e.g., must run on X, team only knows Y)"
   - "What technologies did you deliberately avoid, and why?"
   - "What would be the hardest thing to change about the current architecture?"
   Incorporate answers as additional decision findings.

4. **Propose a dependency tree** — Combine scanner findings and interview answers. Present them as a dependency tree, NOT a flat list. The tree should show how decisions relate:
   ```
   Proposed Technical Decisions:
   ├── [Root decision A]
   │   ├── [Child that depends on A]
   │   └── [Another child that depends on A]
   │       └── [Grandchild]
   ├── [Root decision B]
   │   └── [Child that depends on B]
   └── [Standalone decision C]
   ```
   For each decision in the tree, show: title, category (technical), suggested tags, and a one-line summary.

5. **User reviews the tree** — Ask the user to review the proposed structure. They may want to:
   - Accept as-is
   - Move decisions (change parent/child relationships)
   - Modify titles or summaries
   - Remove decisions that aren't worth recording
   - Add missing decisions

6. **Batch capture** — After the user approves the tree, capture ALL decisions and links together:
   - For each decision, call `mcp__reckon__capture_decision` with:
     - `source: "init"`
     - `sourceRef: "codebase-scan"`
     - `status: "proposed"` (ask user if they want to batch-accept after capture)
     - `category: "technical"`
     - Appropriate tags
   - After all decisions are captured, create dependency links matching the approved tree structure using `mcp__reckon__link_decisions`.

7. **Present summary** — Show the final captured tree with ADR numbers assigned.
