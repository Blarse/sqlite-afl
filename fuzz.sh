#!/bin/sh -efu

mkdir -pv ./out

AFL_CPU=

if [ -z "${1:-}" ]; then
	ROLE=-M
	INSTANCE=master
else
	ROLE=-S
	INSTANCE="slave$1"
	if [ "$1" -eq "$1" ]; then
		 AFL_CPU="$1"
	fi
fi

docker run -it --rm -v "$PWD/out:/home/user/out" \
	-e ROLE="$ROLE" -e INSTANCE="$INSTANCE" -E AFL_CPU="$AFL_CPU" sqlite-afl
