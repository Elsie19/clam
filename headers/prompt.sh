#!/bin/bash

function prompt_input() {
    local prompt="${1:?variable for prompt for prompt_input not given}"
    local var_to_store_to="${2:?variable to store output for prompt_input not given}"
    echo -ne "${1}: "
    read -r prompt_output
    declare -g "${var_to_store_to}=${prompt_output}"
    unset prompt_output
    return 0
}

function prompt_yes_no() {
    local prompt="${1:?variable for prompt for prompt_yes_no not given}"
    local var_to_store_to="${2:?variable to store output for prompt_yes_no not given}"
    echo -ne "${prompt} [${BGreen}y${NC}/${BRed}n${NC}]: "
    read -r prompt_output
    case "${prompt_output}" in
        [Yy]*)
            declare -g "${var_to_store_to}=Y"
            unset prompt_output
            return 0
            ;;
        [Nn]*)
            declare -g "${var_to_store_to}=N"
            unset prompt_output
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
