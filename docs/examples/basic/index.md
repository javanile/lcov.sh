> File: `script.sh`
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

> File: `script-test.sh`
```bash
#!/bin/bash

bash script.sh

exit $?
```

```
$ ../../../bin/lcov.sh script-test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  > DONE script-test.sh: 'Hello World!!' (ok)

Overall coverage rate:
  lines......: 66.7% (4 of 6 lines)
  functions......: no data found
Summary coverage rate:
  lines......: 66.7% (4 of 6 lines)
  functions..: no data found
  branches...: no data found
  tests......: 1 (1 done, 0 fail, 0 skip)
  exit.......: 0 DONE
```

> This is the simplest example: a function that is called `covered_func` and one that is not.

<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>
