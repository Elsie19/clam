#!/bin/bash
# @file array.sh
# @brief A library for interacting with arrays.

# @section Functions
# @description Functions for interacting with arrays.

# @description Converts a string to an array.
# @internal
#
# @example
#   array.string_to_array "foobarbaz" to_array
#
# @arg $1 string A string to convert.
# @arg $2 string An array to put the split string into.
function array.string_to_array() {
    local input array_to
    input="${1:?No input given to array.string_to_array}"
    array_to="${2:?No out array given to array.string_to_array}"

    [[ ${input} =~ ${input//?/(.)} ]]
    declare -ag "${array_to}=(${BASH_REMATCH[*]:1})"
    return $?
}

# @description Pops an array index out
# @internal
#
# @example
#   array=(1 2 3 4)
#   array.pop array 0
#
# @arg $1 string An array name
# @arg $2 string An index to remove
#
# @exitcode 0 If successful.
# @exitcode 1 If array is readonly.
function array.pop() {
    local to_pop array_name
    # `declare -n` is basically like a pointer to an array
    declare -n array_name="${1:?No array given to array.pop}"
    to_pop="${2:?No index given to array.pop}"
    if ! (unset array_name 2> /dev/null); then
        # Is readonly
        return 1
    fi
    unset "array_name[${to_pop}]" || return 1
    if [[ ${array_name@a} != 'A' ]]; then
        array_name=("${array_name[@]}")
    fi
}

# @description Remove a key from an array
# @internal
#
# @example
#   array=(1 2 3 4)
#   array.remove array 1
#
# @arg $1 string An array name
# @arg $2 string A key to remove
#
# @exitcode 0 If successful.
# @exitcode 1 If array is readonly.
function array.remove() {
    local array_name to_remove i
    declare -n array_name="${1:?No array given to array.remove}"
    to_remove="${2:?No element given to array.remove}"

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

# @description Check if array contains a key
# @internal
#
# @example
#   array=(1 2 3 4)
#   array.contain array 3
#
# @arg $1 string An array name
# @arg $2 string A key to search for
#
# @exitcode 0 If array contains key.
# @exitcode 1 If array does not contain key.
function array.contain() {
    local to_search arr i
    declare -n arr="${1:?No array given to array.contain}"
    to_search="${2:?No element given to array.contain}"
    for i in "${arr[@]}"; do
        if [[ ${to_search} == "${i}" ]]; then
            return 0
        fi
    done
    return 1
}

# @description Join array by character
# @internal
#
# @example
#   array=(1 2 3 4)
#   array.join arr ','
#
# @arg $1 string An array name.
# @arg $2 string A character to split IFS.
#
# @stdout An array with IFS split by supplied character
function array.join() {
    local IFS array_name
    declare -n array_name="${1:?No array given to to array.join}"
    local IFS="${2:?No IFS given to array.join}"
    echo "${array_name[*]}"
}

# @description Fill array with input
# @internal
#
# @example
#   array.fill 0 50 "blarb" array
#
# @arg $1 integer A starting index for the array.
# @arg $2 integer Length of array fill.
# @arg $3 Any Text to fill array elements with.
# @arg $4 string Array to fill.
#
# @exitcode 0 If array was successfully filled.
# @exitcode 1 If array is readonly.
function array.fill() {
    local i arr start_index count value
    start_index="${1:?No start index given to array.fill}"
    count="${2:?No count given to array.fill}"
    value="${3:?No value given to array.fill}"
    declare -n arr="${4:?No array given to array.fill}"
    if ! (unset arr 2> /dev/null); then
        # Is readonly
        return 1
    fi
    for ((i = start_index; i < count; i++)); do
        # shellcheck disable=SC2034
        arr[i]="${value}"
    done
}
