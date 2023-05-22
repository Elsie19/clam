#!/bin/bash

function cmds.yes() {
    local text
    text="${1:-y}"
    while :; do
        echo "${text}"
    done
}
