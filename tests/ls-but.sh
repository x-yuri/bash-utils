#!/usr/bin/env bash
set -eu

r=$(pwd)

before() {
    tmp=$(mktemp -d) && trap 'rm -rf "$tmp"' EXIT
    cd "$tmp"
}

after() {
    rm -rf "$tmp"
}

mkfile() {
    local path=$1
    if [[ $path =~ / ]]; then
        local dir=${path%/*}
        mkdir -p "$dir"
    fi
    touch "$path"
}

_mkdir() {
    local path=$1
    mkdir -p "$path"
}

assert() {
    local expected_output=$1
    local expected_exit_code=$2
    local actual_output=$3
    local actual_exit_code=$4
    if [ "$expected_output" != "$actual_output" ] || [ "$expected_exit_code" != "$actual_exit_code" ]; then
        echo "${FUNCNAME[1]}: fail"
        echo expected output: "'$expected_output'" | sed -E 's/^/  /'
        echo actual output: "'$actual_output'" | sed -E 's/^/  /'
        echo expected exit code: "'$expected_exit_code'" | sed -E 's/^/  /'
        echo actual exit code: "'$actual_exit_code'" | sed -E 's/^/  /'
    else
        echo "${FUNCNAME[1]}: success"
    fi
}

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

run_test() {
    before
    $1
    after
}

if [ "${1-}" ]; then
    run_test "$1"
else
    for f in $(declare -fF | awk '{print $NF}' | egrep '^test_'); do
        run_test "$f"
    done
fi
