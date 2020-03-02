
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

test:
	bash lcov.sh test/*.test.sh -x pipetest.sh

docker\:test:
	docker-compose run --rm test
