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
}
