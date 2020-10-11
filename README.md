# LCOV.SH

<img align="right" width="400" height="230" src="https://github.com/javanile/lcov.sh/raw/master/lcov.png">

The best LCOV framework around a BASH project

![.github/workflows/super-linter.yml](https://github.com/javanile/lcov.sh/workflows/.github/workflows/super-linter.yml/badge.svg)
[![Build Status](https://travis-ci.org/javanile/lcov.sh.svg?branch=master)](https://travis-ci.org/javanile/lcov.sh)
[![codecov](https://codecov.io/gh/javanile/lcov.sh/branch/master/graph/badge.svg)](https://codecov.io/gh/javanile/lcov.sh)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e05f81a8c3b54e5f84fb85a4ba70be17)](https://www.codacy.com/manual/francescobianco/lcov.sh?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=javanile/lcov.sh&amp;utm_campaign=Badge_Grade)

## Requirements

## Installation

Download `lcov.sh` file into your local machine

```bash
curl -sL https://git.io/lcov.sh
```

Install `lcov` package into your system

```bash
apt install lcov
```

Check if it working

```bash
bash lcov.sh -v
```

## Usage

Add the following code `[[ -z "${LCOV_DEBUG}" ]] || set -x`
on top of source file you want in a coverage report, see below example:

```bash
#!/usr/bin/env bash
[[ -z "${LCOV_DEBUG}" ]] || set -x

welcome () {
    echo "Hi $1, I'm testable code"
}

welcome "John"
```

Now, run from command line the following command:

```bash
lcov.sh FILE...
```

## Testing

## TL;DR

> not now :-)

### Short url

```bash
curl -i "https://git.io" \
     -d "url=https://raw.githubusercontent.com/javanile/lcov.sh/master/lcov.sh" \
     -d "code=lcov.sh"
```

### Install `lcov` package

Debian/Ubuntu

```bash
apt install lcov
```

Mac OSX

```bash
brew install lcov
```

## See Also

- <http://www.skybert.net/bash/debugging-bash-scripts-on-the-command-line/>
