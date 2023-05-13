#!/bin/bash
# @file ini.sh
# @brief A library for parsing INI files.

# @section Functions
# @description Functions for parsing INI files.

# @description Parses out an INI section.
# @internal
#
# @example
#   ini._parse_out_section "[foobar]"
#
# @arg $1 string An INI section.
#
# @exitcode 1 If section is not valid.
# @stdout A parsed out section
function ini._parse_out_section() {
    local input="${1:?No input given to ini._parse_out_section}"
    # Do we have a valid [section] in terms of []
    if [[ ${input::1} != "[" || ${input: -1} != "]" ]]; then
        return 1
    fi
    echo "${input:1:-1}"
}

# @description Turns INI variable into a Bash variable.
# @set opt-prefix_default-section[var] string Final hashmap
# @internal
#
# @example
#   ini._convert_var "foo = 'bar'"
#
# @arg $1 string An INI variable.
function ini._convert_var() {
    local input="${1:?No input given to ini._convert_var}"
    local var="${input%%=*}"
    local value="${input#*=}"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    declare -Ag "${opt_prefix:+${opt_prefix}_}${default_section}[${var}]=${value}"
}

# @description Converts an INI file into a hashmap.
# @internal
#
# @example
#   ini.parse ~/people.ini
#   ini.parse ~/people.ini Prefix
#
# @arg $1 path An INI file to parse.
# @arg $2 optional A prefix for all keys.
#
# @exitcode 0 If parsed successfully.
# @exitcode 1 If file does not exist, or unsuccessful parse.
function ini.parse() {
    local line
    local file="${1:?No input given to ini.parse}"
    local opt_prefix="${2-}"

    if ! [[ -f ${file} ]]; then
        return 1
    fi

    local default_section="Default"
    local ini_var_regex="^(\w|-)+\s*=\s*(\"|')?(\W|\w)+(\"|')?\$"
    local ini_section_regex='\[([a-zA-Z0-9_ ])+\]$'
    local ini_line_comment='^(\s*)?(#|;).*$'

    local line_counter=0
    while IFS= read -r line; do
        ((line_counter++))
        # Is blank?
        if [[ -z ${line} || ${line} =~ ${ini_line_comment} ]]; then
            continue
        elif [[ ${line} =~ ${ini_section_regex} ]]; then
            if ! ini._parse_out_section "${line}" &> /dev/null; then
                echo "[${line_counter}] Invalid line: ${line}" 2>&1
                return 1
            fi
            default_section="$(ini._parse_out_section "${line}")"
        elif [[ ${line} =~ ${ini_var_regex} ]]; then
            ini._convert_var "${line}"
        else
            echo "[${line_counter}] Invalid line: ${line}" 2>&1
            return 1
        fi
    done < "${file}"
}
