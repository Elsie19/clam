#!/bin/bash

function strings.rev() {
    local str string i
    string="${*:?No input given to strings.rev}"
    for ((i = ${#string} - 1; i >= 0; i--)); do
        str+="${string:i:1}"
    done
    echo "${str:?Could not reverse string}"
}

function strings.strip_leading() {
    local string="${1:?No input given to strings.strip_leading}"
    echo "${string#"${string%%[![:space:]]*}"}"
}

function strings.strip_trailing() {
    local string="${1:?No input given to strings.strip_trailing}"
    echo "${string%"${string##*[![:space:]]}"}"
}

function strings.strip() {
    local string
    local input="${1:?No input given to strings.strip}"
    string=$(strings.strip_leading "${input}")
    string=$(strings.strip_trailing "${string}")
    echo "${string}"
}
