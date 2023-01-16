#!/bin/sh -efu

docker build --build-arg cuid="$(id -u)" --build-arg cgid="$(id -g)" \
	-t "sqlite-afl" -f Dockerfile .
