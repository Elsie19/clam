#!/bin/bash
# @file tuple.sh
# @brief A library for shortening tuple creation.

# @section Functions
# @description Functions for shortening tuple creation.

# @description Creates a tuple.
# @set tuple_contents Any Tuple contents
#
# @example
#   tuple bar "foobarbaz" 1
#
# @arg $1 string The tuple name.
# @arg $@ Any Tuple contents.
function tuple() {
    local tuple_name="${1:?No tuple name given}"
    shift
    local tuple_contents=("${@:?No tuple contents given}")
    declare -agr "${tuple_name}=(${tuple_contents[*]})"
}
