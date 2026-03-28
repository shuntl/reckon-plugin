---
name: init
description: Bootstrap all decision records — runs product scan then technical scan
---

# Initialize All Decision Records

Run both the product and technical decision initialization in sequence.

## Process

1. **Product first** — Run `/reckon:init-product` with $ARGUMENTS (if provided). This scans for product signals and interviews the user about value proposition, target users, and feature boundaries.

2. **Technical second** — After product decisions are captured, run `/reckon:init-technical` with $ARGUMENTS (if provided). This scans configuration files, architecture signals, and interviews the user about technical constraints. Technical decisions will be linked to the product decisions captured in step 1.

3. **Final landscape** — After both are complete, call `mcp__reckon__get_decision_landscape` and show the user a summary of the full decision landscape.
