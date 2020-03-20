.PHONY: deps compile test

deps:
	scripts/dep.sh Olical aniseed origin/develop
	scripts/dep.sh LuaDist bencode 020b69cd51f04adbd0721ac049da461c0692a223

compile:
	rm -rf lua
	deps/aniseed/scripts/compile.sh
	deps/aniseed/scripts/embed.sh aniseed conjure
	cp deps/bencode/bencode.lua lua/conjure/bencode.lua

test:
	rm -rf test/lua
	deps/aniseed/scripts/test.sh
