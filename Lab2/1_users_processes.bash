#!/bin/bash

output_file="users_processes.txt"

echo "$(ps -u "$USER" --no-headers | wc -l)" > "$output_file"
ps -u "$USER" --no-headers -o pid,comm >> "$output_file"
