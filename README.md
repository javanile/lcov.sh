# LCOV.SH

[![Build Status](https://travis-ci.org/javanile/lcov.sh.svg?branch=master)](https://travis-ci.org/javanile/lcov.sh)
[![codecov](https://codecov.io/gh/javanile/lcov.sh/branch/master/graph/badge.svg)](https://codecov.io/gh/javanile/lcov.sh)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e05f81a8c3b54e5f84fb85a4ba70be17)](https://www.codacy.com/manual/francescobianco/lcov.sh?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=javanile/lcov.sh&amp;utm_campaign=Badge_Grade)

```bash
#!/bin/bash
[[ -z "${LCOV_DEBUG}" ]] || set -x

welcome () {
    echo "Hi $1, I'm testable code"
}

welcome "John"
```

See more:
 - http://www.skybert.net/bash/debugging-bash-scripts-on-the-command-line/
