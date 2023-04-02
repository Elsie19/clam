#!/bin/bash

function cmds.whoami() {
    : \\u
    printf '%s\n' "${_@P}"
}
