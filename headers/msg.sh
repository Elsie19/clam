#!/bin/bash

function msg() {
    printf "${BGreen}>${NC} %s\n" "$@"
}

function err() {
    printf "${BRed}>${NC} %s\n" "$@" >&2
}
