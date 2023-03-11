#!/bin/bash

function ini._remove_comments() {
    set -x
    local input="${1}"
    if [[ -z "${input}" ]]; then
        echo ""
    fi
    echo "${input%#*}"
    set +x
}

function ini._parse_out_section() {
    local input="${1:?No input given to ini._parse_out_section}"
    # Do we have a valid [section] in terms of []
    if [[ "${input::1}" != "[" || "${input: -1}" != "]" ]]; then
        return 1
    fi
    echo "${input:1:-1}"
}

function ini._convert_var() {
    local input="${1:?No input given to ini._convert_var}"
    local var="${input%% = *}"
    local value="${input#* = }"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    declare -Ag "${default_section}[${var}]=${value}"
}

function ini.parse() {
    local file="${1:?No input given to ini.parse}"
    # shellcheck disable=SC2034
    local var_prefix="${2-}"

    local default_section="Default"
    if ! [[ -f "${file}" ]]; then
        return 1
    fi

    local ini_var_regex='^(\w)+\s*=\s*(\")?(\w)+(\")?$'
    local ini_section_regex='\[([a-zA-Z0-9_ ])+\]$'
    while IFS= read -r line; do
        # Is blank?
        if [[ -z ${line} ]]; then
            continue
        elif [[ ${line} =~ ${ini_section_regex} ]]; then
            if ! ini._parse_out_section "${line}" &>/dev/null; then
                echo "Invalid line: ${line}!" 2>&1
                return 1
            fi
            default_section="$(ini._parse_out_section "${line}")"
        elif [[ ${line} =~ ${ini_var_regex} ]]; then
            ini._convert_var "${line}"
        fi
    done < "${file}"
}
