---
title: Home
permalink: /
---

# LCOV.SH

> The best LCOV coverage framework for Bash projects.

**lcov.sh** wraps `lcov` and `genhtml` to give you line-coverage reports for your shell scripts —
the same HTML reports you know from C/C++ projects, applied to Bash.

---

## Quick start

```bash
# Install
curl -sL https://lcov.sh/install.sh | bash

# Run your tests and generate a coverage report
lcov.sh -o coverage tests/my-test.sh

# Open the HTML report
open coverage/index.html
```

---

## How it works

1. **`lcov_init`** scans your source files and creates a baseline trace with every line at `DA:N,0`
2. **Test execution** — each test file is run under `bash -x` with a custom `PS4` that records file/line
3. **`lcov_append_info`** parses the xtrace log and marks executed lines as `DA:N,1`
4. **`genhtml`** renders the final HTML report with green (covered) and red (not covered) lines

---

## Coverage report preview

The example below shows a script where `uncovered_func` was never called by the test.
Lines in red were **never executed**.

<iframe width="100%" height="640" src="examples/basic/coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>

---

## Browse examples

- [**Basic**](examples/basic) — covered vs uncovered functions
- [**If / Elif / Else**](examples/if_basic) — tracking branches inside `if` chains
- [**Case Statement**](examples/case_select) — untested `case` arms highlighted in red
- [**Mixed If + Case**](examples/mixed) — real-world nested conditions
