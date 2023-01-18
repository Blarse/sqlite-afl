#!/bin/sh -efu

mkdir -pv ./out

BIND_CORE=

if [ -z "${1:-}" -o "${1:-}" = "0" ]; then
	ROLE=-M
	INSTANCE=master
else
	ROLE=-S
	INSTANCE="slave$1"
fi

if [ "$1" -eq "$1" ]; then
    BIND_CORE="$1"
fi


docker run -it --rm -v "$PWD/out:/home/user/out" \
       -e ROLE="$ROLE" -e INSTANCE="$INSTANCE" \
       -e BIND_CORE="$BIND_CORE" ${BIND_CORE:+--cpuset-cpus $BIND_CORE}\
       sqlite-afl
