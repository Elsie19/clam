#!/bin/bash
# @file strings.sh
# @brief A library for interacting with strings.

# @section Functions
# @description Functions for interacting with strings.

# @description Reverses a string.
# @stdout Reversed string.
#
# @example
#   strings.rev "foobarbaz"
#
# @arg $@ string A string to reverse.
function strings.rev() {
    local str string i
    string="${*:?No input given to strings.rev}"
    for ((i = ${#string} - 1; i >= 0; i--)); do
        str+="${string:i:1}"
    done
    echo "${str:?Could not reverse string}"
}

# @description Strips leading whitespace.
# @see strings.strip
# @stdout Stripped input.
#
# @example
#   strings.strip_leading "     foobarbaz"
#
# @arg $1 string A string to strip.
function strings.strip_leading() {
    local string="${1:?No input given to strings.strip_leading}"
    echo "${string#"${string%%[![:space:]]*}"}"
}

# @description Strips trailing whitespace.
# @see strings.strip
# @stdout Stripped input.
#
# @example
#   strings.strip_trailing "foobarbaz   "
#
# @arg $1 string A string to strip.
function strings.strip_trailing() {
    local string="${1:?No input given to strings.strip_trailing}"
    echo "${string%"${string##*[![:space:]]}"}"
}

# @description Strips leading and trailing whitespace.
# @stdout Stripped input.
#
# @example
#   strings.strip "     foobarbaz   "
#
# @arg $1 string A string to strip.
function strings.strip() {
    local string
    local input="${1:?No input given to strings.strip}"
    string=$(strings.strip_leading "${input}")
    string=$(strings.strip_trailing "${string}")
    echo "${string}"
}
