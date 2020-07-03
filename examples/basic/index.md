```bash
#!/bin/bash

[[ -z "${LCOV_DEBUG}" ]] || set -x

covered_func() {
  echo "Hello $1!"
}

uncovered_func() {
  echo "Great!"
}

covered_func "World!"
```
```bash
#!/bin/bash

bash script.sh

exit $?
```
```bash
$ ../../lcov.sh script-test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  > DONE script-test.sh: 'Hello World!!' (ok)

Reading tracefile coverage/lcov.info
Summary coverage rate:
  lines......: 40.0% (4 of 10 lines)
  functions..: no data found
  branches...: no data found
  tests......: 1 (DONE=1, FAIL=0, SKIP=0
  exit.......: CODE=0 (DONE)
```
<iframe width="100%" height="400" src="coverage/basic"></iframe>
