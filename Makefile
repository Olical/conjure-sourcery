.PHONY: deps compile test

deps:
	mkdir -p deps
	if [ ! -d "deps/aniseed" ]; then git clone https://github.com/Olical/aniseed.git deps/aniseed; fi
	cd deps/aniseed && git fetch && git checkout v2.1.0

compile:
	rm -rf lua
	nvim -u NONE \
		-c "set rtp+=deps/aniseed" \
		-c "lua require('aniseed.compile').glob('**/*.fnl', 'fnl', 'lua')" \
		+q
	cp -r deps/aniseed/lua/aniseed lua/conjure-sourcery/aniseed
	find lua/conjure-sourcery/aniseed -type f -name "*.lua" -exec sed -i 's/"aniseed\./"conjure-sourcery.aniseed./g' {} \;

test:
	rm -rf test/lua
	nvim -u NONE \
		-c "set nomore" \
		-c "set rtp+=deps/aniseed" \
		-c "let &runtimepath = &runtimepath . ',' . getcwd() . ',' . getcwd() . '/test'" \
		-c "lua require('aniseed.compile').glob('**/*.fnl', 'test/fnl', 'test/lua', {force = true}) " \
		-c "lua require('conjure-sourcery-test-suite')" \
		test.clj ; \
		EXIT_CODE=$$?; \
		cat test/results.txt; \
		exit $$EXIT_CODE
