---
description: Show a summary of all active architectural decisions
---

# Decision Summary

Show a compact overview of all active decisions in this repository.

## Process

1. **Parse filter** — If $ARGUMENTS is provided, determine if it's a status value (`draft`, `proposed`, `accepted`, `rejected`, `deprecated`, `under_review`) or a category value (`technical`, `product`). Pass as the appropriate filter.

2. **Load decisions** — Call `mcp__reckon__list_decisions` with the filter and `limit: 100`.

3. **Format output** — Present as a markdown table:

   ```
   | # | Title | Category | Status | Tags | Date |
   |---|-------|----------|--------|------|------|
   ```

4. **Show counts** — Below the table, show:
   - Total decisions
   - Breakdown by status (e.g., "3 accepted, 2 draft, 1 proposed")
   - Breakdown by category (e.g., "4 technical, 2 product")
