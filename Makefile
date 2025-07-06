.PHONY: test

test:
	zig build test -fincremental --watch --prominent-compile-errors
