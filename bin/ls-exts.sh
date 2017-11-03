#!/usr/bin/env bash
set -eu

find -mindepth 1 -type f | sed -E -e 's/([^/]+\/)*//' | sed -nE '/\./p' | sed -E 's/[^.]*\.(.*)/\1/' | sort | uniq
