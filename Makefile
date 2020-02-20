.PHONY: deps compile test prepls

deps:
	scripts/dep.sh Olical aniseed v3.0.0

compile:
	rm -rf lua
	deps/aniseed/scripts/compile.sh
	deps/aniseed/scripts/embed.sh aniseed conjure

test:
	rm -rf test/lua
	make prepl &
	while [ ! -f .prepl-port ]; do sleep 0.2; done
	PREFIX="-c 'syntax on'" deps/aniseed/scripts/test.sh
	echo "(System/exit 0)" | netcat localhost $$(cat .prepl-port)

prepl:
	clj -m propel.main -w
