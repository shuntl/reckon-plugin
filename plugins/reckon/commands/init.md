---
description: Scan codebase for implicit architectural decisions and bootstrap Reckon records
argument-hint: "[optional: focus area e.g. 'database', 'auth', 'testing']"
---

# Initialize Reckon Decision Records

Bootstrap this repository's decision records by scanning the codebase for implicit architectural and product decisions that have already been made but not recorded.

## Process

1. **Check existing records** — Call `mcp__reckon__list_decisions` to see what's already captured. Note existing decisions to avoid duplicates.

2. **Launch scanner** — Launch the `decision-scanner` agent to analyze the codebase. If $ARGUMENTS specifies a focus area, pass it to the agent to narrow the scan.

3. **Review findings** — Present the agent's findings as a numbered list to the user. For each finding, show:
   - Suggested title
   - Category (technical/product)
   - Suggested tags
   - Brief summary of the decision
   - Confidence level (high/medium/low)

4. **Confirm with user** — Ask the user which findings to capture. They may want to:
   - Accept as-is
   - Modify the title or body
   - Skip (not a real decision)
   - Merge multiple findings into one decision

5. **Capture approved decisions** — For each approved finding, call `mcp__reckon__capture_decision` with:
   - `source: "init"`
   - `sourceRef: "codebase-scan"`
   - `status: "proposed"` (init surfaces decisions for review — ask the user if they want to batch-accept them after capture)
   - `category`: as identified by the scanner
   - Appropriate tags

6. **Link related decisions** — After all decisions are captured, identify relationships and call `mcp__reckon__link_decisions` for decisions that depend on each other.

7. **Present summary** — Show a final table of all captured decisions with their numbers, titles, categories, and links.
