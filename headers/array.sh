#!/bin/bash

function array.string_to_array() {
    local input="${1:?No input given to array.string_to_array}"
    local array_to="${2:?No out array given to array.string_to_array}"

    for ((i = 0; i < ${#input}; ++i)); do
        local rematched+=("${input:i:1}")
    done
    declare -ag "${array_to}=(${rematched[*]})"
    return $?
}

function array.pop() {
    # `declare -n` is basically like a pointer to an array
    declare -n array_name="${1:?No array given to array.pop}"
    # shellcheck disable=SC2034
    local to_pop="${2:?No index given to array.pop}"
    if ! (unset array_name 2> /dev/null); then
        # Is readonly
        return 1
    fi
    unset "array_name[${to_pop}]" || return 1
    if [[ ${array_name@a} != 'A' ]]; then
        array_name=("${array_name[@]}")
    fi
}

function array.remove() {
    local array_name
    declare -n array_name="${1:?No array given to array.remove}"
    local to_remove="${2:?No element given to array.remove}"

    if ! (unset array_name 2> /dev/null); then
        # Is readonly
        return 1
    fi

    # If we're dealing with associative arrays
    if [[ ${array_name@a} == 'A' ]]; then
        for i in "${!array_name[@]}"; do
            if [[ ${array_name[${i}]} == "${to_remove}" ]]; then
                unset "array_name[${i}]" || return 1
                break 2
            fi
        done
    else
        for i in "${!array_name[@]}"; do
            if [[ ${array_name[i]} == "${to_remove}" ]]; then
                unset "array_name[${i}]" || return 1
                # Adjust the indices so there are none are jumped
                array_name=("${array_name[@]}")
                break 2
            fi
        done
    fi
    return 0
}

function array.contain() {
    local item="${1:?No \$1 input given to array.contain}"
    shift
    local to_search=("${@:?No \$@ given to array.contain}")
    for i in "${to_search[@]}"; do
        if [[ ${item} == "${i}" ]]; then
            return 0
        fi
    done
    return 1
}

function array.join() {
    local IFS="${1:?No IFS given to array.join}"
    shift
    echo "$*"
}
