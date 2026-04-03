---
description: Bootstrap all records — runs product scan, technical scan, then process scan
---

# Initialize All Records

Run the product, technical, and process initialization in sequence.

## Process

1. **Product first** — Run `/reckon:init_product` with $ARGUMENTS (if provided). This scans for product signals and interviews the user about value proposition, target users, and feature boundaries.

2. **Technical second** — After product decisions are captured, run `/reckon:init_technical` with $ARGUMENTS (if provided). This scans configuration files, architecture signals, and interviews the user about technical constraints. Technical decisions will be linked to the product decisions captured in step 1.

3. **Processes third** — After decisions are captured, scan the codebase for documented and implicit processes. Look for READMEs, CONTRIBUTING.md, CI/CD configs, Makefiles, scripts, and deployment configs that describe workflows and procedures. Propose processes for the user to review, then capture approved ones using `capture_process`. Link processes to the decisions they implement or depend on.

4. **Final landscape** — After all are complete, call `mcp__reckon__get_decision_landscape` and show the user a summary of the full landscape including decisions and processes.
