.PHONY: build run test

build:
	zig build test_compile

run:
	./build_deploy.sh

test:
	echo "no testing setup in this project"
