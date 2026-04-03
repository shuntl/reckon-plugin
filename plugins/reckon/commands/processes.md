---
description: Show a summary of all active processes (workflows, how-tos, runbooks)
---

# Process Summary

Show a compact overview of all active processes in this repository.

## Process

1. **Parse filter** — If $ARGUMENTS is provided, determine if it's a status value (`draft`, `proposed`, `accepted`, `rejected`, `deprecated`, `under_review`) or a category value (`technical`, `product`). Pass as the appropriate filter.

2. **Load processes** — Call `mcp__reckon__list_processes` with the filter and `limit: 100`.

3. **Format output** — Present as a markdown table:

   ```
   | # | Title | Category | Status | Tags | Signals | Date |
   |---|-------|----------|--------|------|---------|------|
   ```

   Use `PRO-` prefix for process numbers (e.g., PRO-001).

4. **Show counts** — Below the table, show:
   - Total processes
   - Breakdown by status (e.g., "3 accepted, 2 draft, 1 proposed")
   - Breakdown by category (e.g., "4 technical, 2 product")
