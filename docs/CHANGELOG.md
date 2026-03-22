---
title: Changelog
permalink: /changelog/
---

All notable changes to lcov.sh are documented here.

## [Unreleased] — mush branch

### Added
- Refactored monolithic `lcov.sh` into mush modules under `src/` — built with `mush build --release`
- Interactive coverage examples under `docs/examples/` with embedded `<iframe>` reports:
  - **Basic** — covered vs uncovered functions
  - **If / Elif / Else** — branch coverage inside `if` chains
  - **Case Statement** — untested `case` arms highlighted red
  - **Mixed If + Case** — real-world nested conditions
- New documentation site at [lcov.sh](https://lcov.sh) with Docs, Examples, and Changelog pages
- `lcov_env()` function for clean source-mode initialization

### Fixed
- Absolute path normalization in `lcov_init` prevents SF path mismatch between baseline and trace
- `lcov_exec` now uses `|| true` pattern to avoid `set -e` triggering on lcov warnings
- BASH_SOURCE check moved to last module so all functions are defined before `return 0`

## [0.1.0] — initial release

### Added
- `lcov.sh` CLI wrapping `lcov` and `genhtml` for bash script coverage
- `bash -x` xtrace-based line coverage collection
- Options: `-o`, `-i`, `-x`, `-e`, `-s`, `-v`, `-h`
- BATS integration
- bpkg compatibility
