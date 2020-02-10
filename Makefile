.PHONY: deps compile test prepls

deps:
	scripts/dep.sh Olical aniseed origin/develop

compile:
	rm -rf lua
	nvim -u NONE \
		-c "set rtp+=deps/aniseed" \
		-c "lua require('aniseed.compile').glob('**/*.fnl', 'fnl', 'lua')" \
		+q
	cp -r deps/aniseed/lua/aniseed lua/conjure/aniseed
	find lua/conjure/aniseed -type f -name "*.lua" -exec sed -i 's/"aniseed\./"conjure.aniseed./g' {} \;

test:
	rm -rf test/lua
	make prepl &
	while [ ! -f .prepl-port ]; do sleep 0.2; done
	nvim -u NONE \
		-c "syntax on" \
		-c "let &runtimepath = &runtimepath . ',' . getcwd() . ',' . getcwd() . '/test'" \
		-c "lua require('conjure.aniseed.compile').glob('**/*.fnl', 'test/fnl', 'test/lua', {force = true})" \
		-c "lua require('conjure.test-suite').main()"; \
		EXIT_CODE=$$?; \
		cat test/results.txt; \
		exit $$EXIT_CODE
	echo "(System/exit 0)" | netcat localhost $$(cat .prepl-port)

prepl:
	clj -m propel.main -w
