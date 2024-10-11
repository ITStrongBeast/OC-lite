#!/bin/bash

while true; 
do
    read -r input

    if [[ ${input} == "q" ]]
    then
        exit 0
    fi

    echo ${#input}

    if [[ ${input} =~ ^[a-zA-Z]+$ ]]
    then
        echo "true"
    else
        echo "false"
    fi
done