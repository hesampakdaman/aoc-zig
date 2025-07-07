.PHONY: test

test:
	zig build test --watch --prominent-compile-errors
