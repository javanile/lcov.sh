
BIN ?= lcov.sh
PREFIX ?= /usr/local

.PHONY: test

ifeq ($(OS),Windows_NT)
    UNAME := Win32
else
    UNAME := $(shell uname -s)
endif

install:
ifeq ($(UNAME),Darwin)
	brew install gnu-getopt lcov
endif
	install ./lcov.sh $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)

getdeps: deps

deps:
	bpkg getdeps

test: deps
	@bash ./lcov.sh test/*.test.sh -x deps

docker-test:
	docker-compose run --rm test

release: build-examples
	git add .
	git commit -am "Release"
	git push

qa:
	curl -sL https://javanile.org/readme-standard/check.sh | bash -

build-examples:
	bash examples/build.sh

## -------
## Testing
## -------
test-bats:
	@rm -fr coverage a.txt
	@bats test/bats

test-get-uuid-function:
	@rm -fr coverage test/coverage
	@bash lcov.sh test/get_uuid.test.sh
