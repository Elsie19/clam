#!/bin/bash
# @file strings.sh
# @brief A library for interacting with strings.

# @section Functions
# @description Functions for interacting with strings.

# @description Reverses a string.
# @internal
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
# @internal
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
# @internal
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
# @internal
# @stdout Stripped input.
#
# @example
#   strings.strip "     foobarbaz   "
#
# @arg $1 string A string to strip.
function strings.strip() {
    local string
    local input="${1:?No input given to strings.strip}"
    string="$(strings.strip_leading "${input}")"
    string="$(strings.strip_trailing "${string}")"
    echo "${string}"
}

# @description Split string by delimeter
# @internal
# @stdout Split output
#
# @example
#   strings.split "foo:bar:baz" ':'
#
# @arg $1 string A string to split.
# @arg $2 char IFS character.
function strings.split() {
    local input IFS split_string_loop
    input="${1:?No input given to strings.split}"
    IFS="${2:?No char given to strings.split}"
    for split_string_loop in ${input}; do
        echo "${split_string_loop}"
    done
}
