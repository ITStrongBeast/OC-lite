#!/bin/bash

input_file="cpu_burst.txt"
output_file="avg_run.txt"
> "$output_file"

current_ppid=""
total_art=0
child_count=0

while IFS= read -r line; do
    pid=$(echo "$line" | awk -F '[:= ]+' '{print $2}')
    ppid=$(echo "$line" | awk -F '[:= ]+' '{print $4}')
    art=$(echo "$line" | awk -F '[:= ]+' '{print $6}')

    if [[ "$current_ppid" != "$ppid" && "$current_ppid" != "" ]]; then
        average=$(echo "scale=6; $total_art / $child_count" | bc)
        echo "Average_Running_Children_of_ParentID=$current_ppid is $average" >> "$output_file"

        total_art=0
        child_count=0
    fi

    echo "$line" >> "$output_file"
    current_ppid=$ppid
    total_art=$(echo "$total_art + $art" | bc)
    ((child_count++))
done < "$input_file"

if [[ "$child_count" -gt 0 ]]; then
    average=$(echo "scale=6; $total_art / $child_count" | bc)
    echo "Average_Running_Children_of_ParentID=$current_ppid is $average" >> "$output_file"
fi
