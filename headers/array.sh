#!/bin/bash

function array.string_to_array() {
    local input="${1:?No input given to array.string_to_array}"
    local array_to="${2:?No out array given to array.string_to_array}"
    local built_array=()

    while IFS= read -r -n1 character; do
        built_array+=("${character}")
    done < <(echo -n "${input}")
    # shellcheck disable=SC2155
    local formatted_output="$(printf "%q " "${built_array[@]}")"
    declare -ag "${array_to}=(${formatted_output})"
    return $?
}

function array.pop() {
    # `declare -n` is basically like a pointer to an array
    declare -n array_name="${1:?No array given to array.pop}"
    # shellcheck disable=SC2034
    local to_pop="${2:?No index given to array.pop}"
    unset "array_name[${to_pop}]"
    if [[ ${array_name@a} != 'A' ]]; then
        array_name=("${array_name[@]}")
    fi
    return $?
}

function array.remove() {
    local array_name
    declare -n array_name="${1:?No array given to array.remove}"
    local to_remove="${2:?No element given to array.remove}"
    local tmp_delete=("${to_remove}")

    # If we're dealing with associative arrays
    if [[ ${array_name@a} == 'A' ]]; then
        for target in "${tmp_delete[@]}"; do
            # Loop over indices instead of elements
            for i in "${!array_name[@]}"; do
                if [[ ${array_name[${i}]} == "${target}" ]]; then
                    unset "array_name[${i}]" || return 1
                    break 2
                fi
            done
        done
    else
        for target in "${tmp_delete[@]}"; do
            for i in "${!array_name[@]}"; do
                if [[ ${array_name[i]} == "${target}" ]]; then
                    unset "array_name[${i}]" || return 1
                    # Adjust the indices so there are none are jumped
                    array_name=("${array_name[@]}")
                    break 2
                fi
            done
        done
    fi
    return 0
}
