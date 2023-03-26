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
    local arr index=0 tmp n
    declare -n arr="${1:?No array given to sort.gnome}"
    n="${#arr[@]}"
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

function sort.insert() {
    local arr i j key length
    declare -n arr="${1:?No array given to sort.insert}"
    length="${#arr[@]}"

    for ((i = 1; i < length; i++)); do
        key="${arr[i]}"
        j="$((i - 1))"
        while ((j >= 0 && key < arr[j])); do
            arr[j + 1]="${arr[j]}"
            ((j--))
        done
        arr[j + 1]="${key}"
    done
}
