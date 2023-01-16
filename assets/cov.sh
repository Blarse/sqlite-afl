#!/bin/sh -eu

rm -f build-cov/*.gcda
echo "Collecting coverage data..."
for i in $(find ./out/*/queue -type f); do
	cat $i | ./build-cov/sqlite3 --safe >/dev/null 2>&1 ||:
done

#llvm-gcov wrapper
cat > llvm-gcov.sh <<EOF
#!/bin/sh
llvm-cov gcov \$@
EOF
chmod +x ./llvm-gcov.sh

mkdir -pv out/cov/{html,gcov}
lcov -d ./build-cov -b ./build-cov --capture \
     --gcov $(readlink -f ./llvm-gcov.sh) -o out/cov/cov.info
genhtml -o out/cov/html out/cov/cov.info
