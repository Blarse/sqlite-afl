#!/bin/sh -efu

#apt-get install tcl libpq-devel libpqxx-devel libsqlite3-devel

mkdir -pv build-afl
pushd build-afl
# NOTE(egori): Trace is disabled because afl quickly discovers
# .trace command which pollutes host system.
../sqlite-version-3.40.1/configure \
	CC=afl-clang-lto \
	LD=afl-ld-lto \
	CPPFLAGS="-DSQLITE_OMIT_TRACE=1" \
	--enable-shared=no \
	--disable-amalgamation \
	--disable-load-extension

make -j $(nproc) sqlite3
popd

mkdir -pv build-cov
pushd build-cov
../sqlite-version-3.40.1/configure \
	CC=clang \
	LD=ld.lld \
	LDFLAGS="--coverage" \
	CFLAGS="-fprofile-arcs -ftest-coverage" \
	CPPFLAGS="-DSQLITE_OMIT_TRACE=1" \
	--enable-shared=no \
	--disable-amalgamation \
	--disable-load-extension

make -j $(nproc) sqlite3
popd

pushd sqlsmith-1.4
mkdir -pv build
cd build
../configure \
	CC=clang \
	CXX=clang++ \
	LD=ld.lld
make -j $(nproc)
popd

mkdir -pv in
pushd in
../sqlsmith-1.4/build/sqlsmith \
	--max-queries=100 \--seed=47 --dry-run --sqlite 2>/dev/null | \
	csplit - "/;/+1" "{*}"
popd
