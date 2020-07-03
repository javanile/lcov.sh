# Examples
...
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
$ ls
coverage
script.sh
script.test.sh
```
<iframe width="100%" height="400" src="basic/coverage/"></iframe>
