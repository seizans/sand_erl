.PHONY: all compile deps clean test dev pkg

all: clean deps test

deps:
	@./rebar3 upgrade
	@./rebar3 compile

compile:
	./rebar3 compile
	./rebar3 xref

dev: compile
	./rebar3 release

pkg: compile
	@./rebar3 as prod release

test: compile
	@./rebar3 eunit
	@./rebar3 cover

clean:
	@./rebar3 clean
