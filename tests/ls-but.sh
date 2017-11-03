#!/usr/bin/env bash
set -eu

test_file() {
    mkfile a
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert './a' 0 "$o" "$e"
}

test_dir() {
    _mkdir a
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert '' 0 "$o" "$e"
}

test_ignore_ext() {
    mkfile a.png
    e=0; o=`$r/bin/ls-but.sh \*.png` || e=$?
    assert '' 0 "$o" "$e"
}

test_ignore_dir() {
    mkfile a/b
    e=0; o=`$r/bin/ls-but.sh a` || e=$?
    assert '' 0 "$o" "$e"
}

test_ignore_file() {
    mkfile a
    e=0; o=`$r/bin/ls-but.sh a` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_file() {
    mkfile a/b
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert './a/b' 0 "$o" "$e"
}

test_dir_dir() {
    _mkdir a/b
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_ignore_ext() {
    mkfile a/b.png
    e=0; o=`$r/bin/ls-but.sh \*.png` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_ignore_dir() {
    mkfile a/b/c
    e=0; o=`$r/bin/ls-but.sh a/b` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_ignore_file() {
    mkfile a/b
    e=0; o=`$r/bin/ls-but.sh a/b` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_ignore_nonexistent_entry() {
    e=0; o=`$r/bin/ls-but.sh a` || e=$?
    assert '' 0 "$o" "$e"
}

. tests/run.sh
