---
description: Bootstrap all decision records — runs technical scan then product scan
argument-hint: "[optional: focus area e.g. 'database', 'auth']"
---

# Initialize All Decision Records

Run both the technical and product decision initialization in sequence.

## Process

1. **Technical first** — Run `/reckon:init-technical` with $ARGUMENTS (if provided). This scans configuration files, architecture signals, and interviews the user about technical constraints.

2. **Product second** — After technical decisions are captured, run `/reckon:init-product` with $ARGUMENTS (if provided). This scans for product signals and interviews the user about value proposition, target users, and feature boundaries. Product decisions will be linked to the technical decisions captured in step 1.

3. **Final landscape** — After both are complete, call `mcp__reckon__get_decision_landscape` and show the user a summary of the full decision landscape.
