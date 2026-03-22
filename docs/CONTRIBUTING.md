---
title: Contributing
permalink: /contributing/
---

# Contributing

Contributions are welcome! Here is how to get started.

---

## Development setup

```bash
git clone https://github.com/javanile/lcov.sh
cd lcov.sh

# Build from source modules
mush build --release
# Output: bin/lcov.sh
```

Requires [mush](https://github.com/javanile/mush) and `lcov` / `genhtml` installed.

---

## Project structure

```
src/
  main.sh       # entry point, arg parsing, lcov_env()
  usage.sh      # usage() help text
  utils.sh      # get_files(), log(), error(), get_uuid()
  lcov.sh       # lcov_init(), lcov_exec(), lcov_append_info(), lcov_done()
  test.sh       # lcov_test(), lcov_test_wait(), lcov_test_check()
  bats.sh       # BATS integration, BASH_SOURCE guard

tests/
  bare/         # unit tests for individual functions
  pipetest.sh   # assertion library

docs/
  examples/     # interactive coverage example pages
```

---

## Running tests

```bash
# Run all bare tests
bash tests/bare/run.sh

# Rebuild documentation examples
bash docs/examples/build.sh
```

---

## Submitting changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-change`
3. Commit using [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, etc.
4. Open a pull request against `main`

Please keep pull requests focused — one logical change per PR.
