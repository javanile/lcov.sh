# LCOV.SH

> LCOV framework for Shell projects

![.github/workflows/super-linter.yml](https://github.com/javanile/lcov.sh/workflows/.github/workflows/super-linter.yml/badge.svg)
[![Build Status](https://travis-ci.com/javanile/lcov.sh.svg?branch=master)](https://travis-ci.org/javanile/lcov.sh)
[![codecov](https://codecov.io/gh/javanile/lcov.sh/branch/master/graph/badge.svg)](https://codecov.io/gh/javanile/lcov.sh)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e05f81a8c3b54e5f84fb85a4ba70be17)](https://www.codacy.com/manual/francescobianco/lcov.sh?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=javanile/lcov.sh&amp;utm_campaign=Badge_Grade)

## Requirements

- BASH 4.* or greater
- LCOV package ([Ubuntu](http://manpages.ubuntu.com/manpages/focal/man1/lcov.1.html))

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

### Usage

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

### Suggestion

Use this link to post any soggestion <https://lcov.hearken.io/>

### Testing

> Work in progress

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

### See Also

- <http://www.skybert.net/bash/debugging-bash-scripts-on-the-command-line/>

### Changelog

Please see [CHANGELOG](docs/CHANGELOG.md) for more information on what has changed recently.

### Testing

```bash
make install && make test 
```

### Contributing

Please see [CONTRIBUTING](docs/CONTRIBUTING.md) for details.

### Campaigns

We highly appreciate if you create a social post on facebook or twitter with following hashtag:

- [#Javanile](#javanile)
- [#LCOVSH](#lcovsh)
- [#LCOV](#lcovsh)
- [#DEVCommunity](#DEVCommunity)

### Credits

- [Francesco Bianco](https://github.com/francescobianco)
- [All Contributors](../../contributors) 

### Support us

Javanile is a community project agency based in Sicily, Italy. 
You'll find an overview of all our projects [on our website](https://www.javanile.org).

Does your business depend on our contributions? Reach out and support us on [Patreon](https://www.patreon.com/javanile). 

### Security

If you discover any security related issues, please email bianco@javanile.org instead of using the issue tracker.

### License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
