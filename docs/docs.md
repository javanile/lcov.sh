---
title: Docs
permalink: /docs/
---

## Installation

```bash
curl get.javanile.org/lcov | sh
```

This installs `lcov.sh` to `/usr/local/bin`. Requires `lcov` and `genhtml` to be available:

```bash
# Ubuntu / Debian
apt-get install lcov

# macOS
brew install lcov
```

---

## Usage

```
lcov.sh [OPTIONS] <test-file> [test-file ...]
```

### Options

| Flag | Description |
|------|-------------|
| `-o, --output DIR` | Write HTML output to `DIR` (default: `coverage`) |
| `-i, --include PATH` | Include specific files for coverage tracking |
| `-x, --exclude PATH` | Exclude files matching `PATH` |
| `-e, --extension EXT` | Track files with extension `EXT` (default: `sh`) |
| `-s, --stop-on-failure` | Stop immediately if a test fails |
| `-v, --version` | Show version |
| `-h, --help` | Show help |

---

## How it works

lcov.sh uses bash's built-in `xtrace` (`bash -x`) with a custom `PS4` prompt to record which
lines are executed during a test run. The trace is then converted into `.info` format that
`genhtml` understands.

### Step by step

1. **Baseline** — `lcov_init` scans your source files and writes a `.info` file with every
   executable line at hit count `0`.

2. **Execution** — each test file is sourced under `bash -x` with:
   ```
   PS4='+:lcov.sh:${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
   ```
   Every executed line produces a trace line like `+:lcov.sh:/path/to/script.sh:42:func: `.

3. **Merge** — `lcov_append_info` parses the xtrace output, counts hits per line, and
   merges them with the baseline `.info`.

4. **Report** — `genhtml` renders the final HTML with green (covered) and red (not covered)
   lines, plus summary statistics.

---

## Source mode

`lcov.sh` can also be sourced to use individual functions directly in your test scripts:

```bash
source lcov.sh

lcov_env coverage
lcov_init -i my-script.sh
lcov_test my-test.sh
lcov_done
```

### API

| Function | Description |
|----------|-------------|
| `lcov_env DIR` | Initialize output paths for `DIR` |
| `lcov_init [OPTIONS]` | Create baseline `.info` from source files |
| `lcov_test FILE` | Run a test file and collect coverage |
| `lcov_done` | Finalize and generate HTML report |
| `lcov_append_info FILE` | Parse one xtrace log and merge into coverage |

---

## Environment variables

| Variable | Description |
|----------|-------------|
| `LCOV_DEBUG_LOG` | Path to write full debug log |
| `LCOV_DEBUG_NO_COLOR` | Set to any value to disable colored output |

---

## Examples

See the [Examples](../examples/) page for interactive coverage reports demonstrating
`if/elif/else` branches, `case` statements, and mixed conditions.
