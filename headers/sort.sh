#!/bin/bash

function sort.bubble() {
    local arr flag=1 tmp length i j
    declare -n arr="${1:?No array given to sort.bubble}"

    length="${#arr[@]}"

    for ((i = 0; i < length - 1; i++)); do
        flag=0
        for ((j = 0; j < length - 1 - i; j++)); do
            if ((arr[j] > arr[j + 1])); then
                tmp=${arr[j]}
                arr[j]=${arr[j + 1]}
                arr[j + 1]="${tmp}"
                flag=1
            fi
        done

        if ((flag == 0)); then
            break
        fi
    done
}

function sort.gnome() {
    local arr index tmp n
    declare -n arr="${1:?No array given to sort.gnome}"
    n="${#arr[@]}"
    index=0
    while ((index < n)); do
        if ((index == 0)); then
            ((index++))
        fi
        if ((arr[index] >= arr[index - 1])); then
            ((index++))
        else
            tmp=0
            tmp="${arr[index]}"
            arr[index]="${arr[index - 1]}"
            arr[index - 1]="${tmp}"
            ((index--))
        fi
    done
}
