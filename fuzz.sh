#!/bin/sh -efu

export AFL_SKIP_CPUFREQ=1

mkdir -pv ./out
cd ./out
afl-fuzz -i ../in/ -o . -x ../sql.dict -- ../build-afl/sqlite3 --safe
