#!/bin/sh -efu

export AFL_SKIP_CPUFREQ=1

mkdir -pv ./out
cd ./out
AFL_AUTORESUME=1 afl-fuzz -D -i ../in/ -o . -x ../sql.dict -- ../build-afl/sqlite3 --safe
