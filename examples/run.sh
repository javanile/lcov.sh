#!/usr/bin/env bash
set -e

##
# Run all lcov.sh examples and show line coverage detail.
# Each example only covers SOME branches to demonstrate uncovered paths.
#
# Usage: bash examples/run.sh
##

BIN="./bin/lcov.sh"
EXAMPLES=(if_basic case_select mixed)

show_coverage_detail() {
    local info_file="$1"
    local script_file="$2"

    echo "  Lines tracked in ${script_file}:"

    local lineno=0
    while IFS= read -r source_line; do
        lineno=$((lineno + 1))
        # Trim whitespace
        source_line="${source_line#"${source_line%%[![:space:]]*}"}"
        [[ -z "$source_line" ]] && continue

        # Check DA entry for this line in lcov.info
        local hits
        hits=$(grep "^DA:${lineno}," "$info_file" 2>/dev/null | cut -d',' -f2 || echo "")

        if [[ -n "$hits" ]]; then
            if [[ "$hits" -gt 0 ]]; then
                printf "    \033[32m[COVERED  ] line %3d: %s\033[0m\n" "$lineno" "$source_line"
            else
                printf "    \033[31m[NOT COVERED] line %3d: %s\033[0m\n" "$lineno" "$source_line"
            fi
        fi
    done < "$script_file"
}

for example in "${EXAMPLES[@]}"; do
    echo ""
    echo "══════════════════════════════════════════════"
    echo "  Example: ${example}"
    echo "══════════════════════════════════════════════"

    script="./examples/${example}/script.sh"
    test_file="./examples/${example}/test.sh"
    outdir="./examples/${example}/coverage"

    rm -fr "$outdir"

    # -e xyz: use non-existent extension so only -i includes are tracked
    # -i script: track only this example's script
    "$BIN" \
        -e xyz \
        -o "$outdir" \
        -i "$script" \
        "$test_file"

    echo ""
    show_coverage_detail "${outdir}/lcov.info" "$script"
    echo ""
    echo "  HTML report: ${outdir}/index.html"
done

echo ""
echo "══════════════════════════════════════════════"
echo "  Done. Open the HTML reports to browse coverage."
echo "══════════════════════════════════════════════"
