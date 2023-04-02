#!/bin/bash

function cmds.whoami() {
    : \\u
    echo "${_@P}"
}
