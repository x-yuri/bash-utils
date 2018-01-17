#!/usr/bin/env bash
set -eu

test_file() {
    mkfile 'a b'
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert './a b' 0 "$o" "$e"
}

test_dotfile() {
    mkfile '.a b'
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert './.a b' 0 "$o" "$e"
}

test_dir() {
    _mkdir 'a b'
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert '' 0 "$o" "$e"
}

test_ignore_ext() {
    mkfile 'a b.c d'
    e=0; o=`$r/bin/ls-but.sh '*.c d'` || e=$?
    assert '' 0 "$o" "$e"
}

test_ignore_dir() {
    mkfile 'a b/c d'
    e=0; o=`$r/bin/ls-but.sh 'a b'` || e=$?
    assert '' 0 "$o" "$e"
}

test_ignore_file() {
    mkfile 'a b'
    e=0; o=`$r/bin/ls-but.sh 'a b'` || e=$?
    assert '' 0 "$o" "$e"
}

test_ignore_subdir() {
    mkfile 'a b/c d'
    e=0; o=`$r/bin/ls-but.sh 'c d'` || e=$?
    assert './a b/c d' 0 "$o" "$e"
}

test_dir_file() {
    mkfile 'a b/c d'
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert './a b/c d' 0 "$o" "$e"
}

test_dir_dir() {
    _mkdir 'a b/c d'
    e=0; o=`$r/bin/ls-but.sh` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_ignore_ext() {
    mkfile 'a b/c d.e f'
    e=0; o=`$r/bin/ls-but.sh '*.e f'` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_ignore_dir() {
    mkfile 'a b/c d/e f'
    e=0; o=`$r/bin/ls-but.sh 'a b/c d'` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_ignore_file() {
    mkfile 'a b/c d'
    e=0; o=`$r/bin/ls-but.sh 'a b/c d'` || e=$?
    assert '' 0 "$o" "$e"
}

test_dir_ignore_nonexistent_entry() {
    e=0; o=`$r/bin/ls-but.sh 'a b'` || e=$?
    assert '' 0 "$o" "$e"
}

. tests/run.sh
