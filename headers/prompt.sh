#!/bin/bash

function prompt_input() {
    echo -ne "${1:?}: "
    read -r prompt_output
    echo "${prompt_output}"
}

function prompt_yes_no() {
    local prompt="${1:?variable for prompt for prompt_yes_no not given}"
    local var_to_store_to="${2:?variable to store output for prompt_yes_no not given}"
    echo -ne "${prompt} [${GREEN}y${NC}/${RED}n${NC}]: "
    read -r prompt_output
    case "${prompt_output}" in
        [Yy]*)
	    declare -g "${var_to_store_to}=Y"
            ;;
        [Nn]*)
	    declare -g "${var_to_store_to}=N"
            ;;
        *)
            return 1
            ;;
    esac
}
