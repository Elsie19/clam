#!/bin/bash
# @file assert.sh
# @brief A library for asserting information.

# @section Functions
# @description Functions for asserting information.

# @description Checks for root.
# @internal
# @noargs
#
# @example
#   if assert.is_root; then
#       echo "I am root"
#   fi
#
# @exitcode 0 If is root.
# @exitcode 1 If is not root.
function assert.is_root() {
    return $(("${EUID}" == 0 ? 0 : 1))
}
