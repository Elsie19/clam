#!/bin/bash
# @file msg.sh
# @brief A library for outputing text.

# @section Functions
# @description Functions for output text.

# @description Prints out text.
#
# @example
#   msg "foobar"
#
# @arg $@ string Text to output
#
# @stdout Your message prefixed by '>'
function msg() {
    local flags=("-e")
    if [[ ${1} == "-n" ]]; then
        flags+=("-n")
        shift
    fi
    echo "${flags[@]}" "${BGreen-}>${NC} $*"
}
