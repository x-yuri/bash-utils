#!/usr/bin/env bash
set -eu

test_ext() {
    mkfile 'a b.c d'
    e=0; o=`$r/bin/ls-exts.sh` || e=$?
    assert 'c d' 0 "$o" "$e"
}

test_dir() {
    _mkdir 'a b.c d'
    e=0; o=`$r/bin/ls-exts.sh` || e=$?
    assert '' 0 "$o" "$e"
}

test_two_dots() {
    mkfile 'a b.c d.e f'
    e=0; o=`$r/bin/ls-exts.sh` || e=$?
    assert 'c d.e f' 0 "$o" "$e"
}

test_dot_files() {
    mkfile '.a b'
    e=0; o=`$r/bin/ls-exts.sh` || e=$?
    assert 'a b' 0 "$o" "$e"
}

. tests/run.sh
