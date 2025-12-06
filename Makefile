.PHONY: test

test:
	watchexec -e zig 'zig build test -fincremental'
