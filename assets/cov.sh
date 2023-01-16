#!/bin/sh -efu

for i in $(find ./out/default/queue -type f); do
	cat $i | ./build-cov/sqlite3 --safe 2>&1 >/dev/null ||:
done

lcov --directory ./build-cov --base-directory ./build-cov --capture -o ./cov.info
