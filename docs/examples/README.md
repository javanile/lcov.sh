---
title: Examples
permalink: /examples/
---

# Examples

Each example shows a real bash script, its test file, the lcov.sh output, and an interactive
coverage report embedded via `<iframe>`.

## Available examples

| Example | What it demonstrates | Coverage |
|---------|----------------------|----------|
| [Basic](basic) | Covered vs uncovered functions | ~40% |
| [If / Elif / Else](if_basic) | Uncovered branches in `if` chains | ~50% |
| [Case Statement](case_select) | Untested `case` arms | ~43% |
| [Mixed If + Case](mixed) | Real-world nested conditions | ~55% |

## How to rebuild

Run from the project root:

```bash
bash docs/examples/build.sh
```

This re-generates coverage HTML and `index.md` for every example.
