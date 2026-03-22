#!/usr/bin/env bash
set -e

##
# Build all documentation examples.
# Run from the project root: bash docs/examples/build.sh
##

export LCOV_DEBUG_NO_COLOR=yes

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BIN="${ROOT}/bin/lcov.sh"
EXAMPLES="${ROOT}/docs/examples"

##
# Print file content as a markdown code block.
##
code() {
  local file="$1"
  echo "> File: \`$(basename "$file")\`"
  echo '```bash'
  cat "$file"
  echo '```'
}

##
# Run a command and wrap its output in a code block.
##
dump() {
  echo '```'
  echo "$ $*"
  "$@"
  echo '```'
}

##
# Build a new-style example (run from inside the example dir so relative paths work).
# Usage: build_new_example <name> <title> <description> <note>
##
build_new_example() {
  local name="$1"
  local title="$2"
  local description="$3"
  local note="$4"
  local dir="${EXAMPLES}/${name}"

  echo "  Building: ${name}..."

  local output
  output=$(
    cd "${dir}"
    rm -fr coverage
    "${BIN}" -e xyz -o coverage -i script.sh test.sh 2>&1
  )

  (
    echo "# ${title}"
    echo ""
    echo "${description}"
    echo ""
    code "${dir}/script.sh"
    echo ""
    code "${dir}/test.sh"
    echo ""
    echo '```'
    echo "$ lcov.sh -e xyz -o coverage -i script.sh test.sh"
    echo "${output}"
    echo '```'
    echo ""
    echo "> ${note}"
    echo ""
    echo '<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>'
  ) > "${dir}/index.md"
}

##
# Build the original basic example (run from inside the example dir).
##
build_basic_example() {
  echo "  Building: basic..."
  local dir="${EXAMPLES}/basic"
  (
    cd "${dir}"
    rm -fr coverage
    (
      code script.sh
      echo ""
      code script-test.sh
      echo ""
      dump ../../../bin/lcov.sh script-test.sh
      echo ""
      echo "> This is the simplest example: a function that is called \`covered_func\` and one that is not."
      echo ""
      echo '<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>'
    ) > index.md
  )
}

echo "Building docs examples..."
echo ""

build_basic_example
build_new_example "if_basic" \
  "Example: If / Elif / Else Coverage" \
  "This example demonstrates how lcov.sh tracks **line coverage inside \`if\`, \`elif\`, and \`else\` branches**. The test only exercises a subset of paths — uncovered branches are highlighted in the report." \
  "The red lines below are branches that were **never executed** by the test."

build_new_example "case_select" \
  "Example: Case Statement Coverage" \
  "This example demonstrates how lcov.sh tracks **line coverage inside \`case\` statements**. Only two HTTP status codes and two log levels are tested — the rest show as uncovered." \
  "Each untested \`case\` branch appears red — helping you identify missing test scenarios."

build_new_example "mixed" \
  "Example: Mixed If + Case Coverage" \
  "This example combines **nested \`if\` guards and a \`case\` dispatch** to show how lcov.sh handles real-world scripts where multiple code paths exist simultaneously." \
  "The coverage report shows exactly which error paths, roles, and access denials were never tested."

echo ""
echo "Done. All examples built."
