#!/bin/bash
# @file prompt.sh
# @brief A library for interacting with the user.

# @section Functions
# @description Functions for interacting with the user.

# @description Prompts the user for input.
# @internal
# @set var_to_store_to Any Prompt input.
# @stdin The users input
#
# @example
#   prompt.input "Do you like cheese" like_cheese
#
# @arg $1 string A prompt.
# @arg $2 string A variable to save the output to.
function prompt.input() {
    local prompt var_to_store_to prompt_output
    prompt="${1:?variable for prompt for prompt_input not given}"
    var_to_store_to="${2:-REPLY}"
    echo -ne "${1}: "
    IFS= read -r prompt_output
    declare -g "${var_to_store_to}=${prompt_output}"
    return 0
}

# @description Prompts the user for a yes or no question.
# @internal
# @set var_to_store_to Any Prompt input.
# @stdin The users input
#
# @example
#   prompt.yes_no "Do you like cheese" yes_no
#
# @arg $1 string A prompt.
# @arg $2 string A variable to save the output to.
#
# @exitcode 1 If user input is not `Y` or `N`.
function prompt.yes_no() {
    local prompt var_to_store_to prompt_output
    prompt="${1:?variable for prompt for prompt_yes_no not given}"
    var_to_store_to="${2:-REPLY}"
    echo -ne "${prompt} [${BGreen-}y${NC}/${BRed-}n${NC}]: "
    IFS= read -r prompt_output
    case "${prompt_output}" in
        [Yy]*)
            declare -g "${var_to_store_to}=Y"
            return 0
            ;;
        [Nn]*)
            declare -g "${var_to_store_to}=N"
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
