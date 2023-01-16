#!/bin/sh -efu

docker run -it --rm -v "$PWD/out:/home/user/out" \
       sqlite-afl ./cov.sh
