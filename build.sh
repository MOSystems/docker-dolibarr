#!/bin/bash
set -e
version=10.0.3
checksum=96c256b8f8b1136aab2cd693cc242eb6806be138
for debug in "true" "false"; do
    echo "Building Dolibarr version $version$([ "$debug" = "true" ] && echo "with debug enabled")"
    docker build \
        --build-arg debug="$debug" \
        --build-arg version="$version" \
        --build-arg checksum="$checksum" \
        -t mosystems/dolibarr:${version%%.*}$([ "$debug" = "true" ] && echo -debug) \
        -t mosystems/dolibarr:${version%.*}$([ "$debug" = "true" ] && echo -debug) \
        -t mosystems/dolibarr:${version}$([ "$debug" = "true" ] && echo -debug) \
        .
done