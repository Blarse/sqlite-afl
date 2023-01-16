#!/bin/sh -efu

export AFL_SKIP_CPUFREQ=1
export AFL_AUTORESUME=1

mkdir -pv ./out
afl-fuzz -i ./in -o ./out -x ./sql.dict \
	 ${ROLE:--M} ${INSTANCE:-master} ${AFL_CORE:+-b $AFL_CORE} \
	 -- ../build-afl/sqlite3 --safe
