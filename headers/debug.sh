#!/bin/bash

function debug.on() {
    # Thanks to @sirhalos (https://github.com/sirhalos/bash-standard-library/blob/master/__init__.sh#L41)
    declare -gx PS4=$'\U1F50D \E[0;10m\E[1m\033[1;31m\033[1;37m[\033[1;35m$(basename ${BASH_SOURCE[0]}):\033[1;34m${FUNCNAME[0]:-NOFUNC}():\033[1;33m${LINENO}\033[1;37m] - \033[1;33mDEBUG: \E[0;10m'
    set -vx
}

function debug.off() {
    set +vx
}
