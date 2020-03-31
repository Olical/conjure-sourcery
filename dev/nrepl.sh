#!/usr/bin/env bash

clj -Sdeps '{:deps {nrepl {:mvn/version "0.7.0"}}}' -m nrepl.cmdline --interactive
