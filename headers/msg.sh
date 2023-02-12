#!/bin/bash

function msg() {
    echo -e "${BGreen}>${NC} $*"
}

function err() {
    echo -e "${BRed}>${NC} $*" >&2
}
