#!/usr/bin/env bash
set -eu

find_ignore() {
    local depth=$1
    local dir=$2
    local type=$3
    shift 3
    local ignore=("$@")
    local n args=()
    args+=("${dir:-.}")
    if [ "$depth" ]; then
        args+=(-mindepth "$depth" -maxdepth "$depth")
    fi
    if [ "$type" ]; then
        args+=(-type "$type")
    fi
    for n in "${ignore[@]}"; do
        args+=(! -name "$n")
    done
    find "${args[@]}"
}

ignore_exts=()
ignore_entries=()
for a; do
    if [[ $a =~ ^\* ]]; then
        ignore_exts+=("$a")
    else
        ignore_entries+=("$a")
    fi
done

process_dir() {
    local dir=$1
    shift 1
    local ignore_entries=("$@")
    local d d2 cur_ignore_entries new_ignore_entries
    local dirs_string ignored_dirs_string non_ignored_dirs_string
    local non_ignored_dirs ignored_dirs

    cur_ignore_entries=("${ignore_entries[@]%%/*}")
    _IFS=$IFS
    IFS=$'\n'
    cur_ignore_entries=($(printf "%s\n" "${cur_ignore_entries[@]}"))
    IFS=$_IFS

    find_ignore 1 "$dir" f "${cur_ignore_entries[@]}" "${ignore_exts[@]}"

    dirs_string=$(find_ignore 1 "$dir" d)
    non_ignored_dirs_string=$(find_ignore 1 "$dir" d "${cur_ignore_entries[@]}")
    ignored_dirs_string=$(comm -2 -3 <(echo "$dirs_string" | sort) <(echo "$non_ignored_dirs_string" | sort))

    _IFS=$IFS
    IFS=$'\n'
    ignored_dirs=($ignored_dirs_string)
    non_ignored_dirs=($non_ignored_dirs_string)
    IFS=$_IFS

    for d in "${non_ignored_dirs[@]}"; do
        find_ignore '' "$d" f "${ignore_exts[@]}"
    done

    for d in "${ignored_dirs[@]}"; do
        d=${d##*/}
        new_ignore_entries=()
        for d2 in "${ignore_entries[@]}"; do
            if [ "$d" = "$d2" ]; then
                continue 2
            fi
            if [ "$d" = "${d2%%/*}" ]; then
                new_ignore_entries+=("${d2#*/}")
            fi
        done
        process_dir "$dir/$d" "${new_ignore_entries[@]}"
    done
}

process_dir . "${ignore_entries[@]}"
