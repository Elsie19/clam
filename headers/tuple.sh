#!/bin/bash

function tuple() {
    local tuple_name="${1:?No tuple name given}"
    shift
    local tuple_contents=("${@:?No tuple contents given}")
    declare -agr "${tuple_name}=(${tuple_contents[*]})"
}
