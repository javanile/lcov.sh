
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

getdeps:
	bpkg getdeps

test:
	bash lcov.sh test/*.test.sh -x pipetest.sh

docker-test:
	docker-compose run --rm test

release:
	git add .
	git commit -am "Release"
	git push