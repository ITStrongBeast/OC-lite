#!/bin/bash

counter=0
array=()
report_file=$1
> "$report_file"

while true; do
    array+=({1..10})
    ((counter++))

    if (( counter % 100000 == 0 )); then
        echo "Шаг $counter: ${#array[@]}" >> "$report_file"
    fi
done
