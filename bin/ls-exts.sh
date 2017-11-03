#!/usr/bin/env bash
set -eu

find -mindepth 1 -type f | sed -E 's/([^/]+\/)*[^.]*\.(.*)/\2/' | sort | uniq
