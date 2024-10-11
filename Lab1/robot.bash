#!/bin/bash

field_width=$1
field_height=$2

x=$((field_width / 2))
y=$((field_height / 2))

while true; 
do
    echo "x=$x;y=$y"

    read -n1 input

    if [[ ${input} == "q" ]]
    then
        exit 0
    fi

    case ${input,,} in
        "w") y=$((y + 1)) ;;
        "s") y=$((y - 1)) ;; 
        "a") x=$((x - 1)) ;;  
        "d") x=$((x + 1)) ;;  
    esac

    if [[ ${x} -lt 0 || ${x} -gt $((field_width - 1)) || \
        ${y} -lt 0 || ${y} -gt $((field_height - 1)) ]]
    then
        exit 1
    fi
done