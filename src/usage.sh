
usage() {
  echo "Usage: ./lcov.sh [OPTION]... FILE..."
  echo ""
  echo "Executes FILE as a test case also collect each LCOV info and generate HTML report"
  echo ""
  echo "List of available options"
  echo "  -e, --extension EXT      Coverage of every *.EXT file (default: sh)"
  echo "  -i, --include PATH       Include files matching PATH"
  echo "  -x, --exclude PATH       Exclude files matching PATH"
  echo "  -o, --output OUTDIR      Write HTML output to OUTDIR"
  echo "  -s, --stop-on-failure    Stop analysis if a test fails"
  echo "  -h, --help               Display this help and exit"
  echo "  -v, --version            Display current version"
  echo ""
  echo "Documentation can be found at https://github.com/javanile/lcov.sh"
}

