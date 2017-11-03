#!/usr/bin/env bash
set -eu

if [ -t 0 ]; then
    find -mindepth 1 -type f
else
    cat
fi | sed -E -e 's/([^/]+\/)*//' | sed -nE '/\./p' | sed -E 's/[^.]*\.(.*)/\1/' | sort | uniq
