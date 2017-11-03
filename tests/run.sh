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
