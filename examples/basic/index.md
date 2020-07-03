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
$ ./lcov.sh script-test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  > [1m[32m(done)[0m script-test.sh: 'Hello World!!' (ok)

Reading tracefile coverage/lcov.info
Summary coverage rate:
  lines......: 2.3% (4 of 173 lines)
  functions..: no data found
  branches...: no data found
  tests......: 1 (1 done, 0 fail, 0 skip)
  exit.......: 0 [1m[32m(done)[0m
```
<iframe width="100%" height="400" src="coverage/"></iframe>
