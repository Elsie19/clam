#!/bin/bash

function cmds.yes() {
    local text
    text="${1:-y}"
    while true; do
        echo "${text}"
    done
}
