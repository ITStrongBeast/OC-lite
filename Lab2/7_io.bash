#!/bin/bash

temp_file="temp_file.txt"

for pid in $(ls /proc | egrep '^[0-9]+$'); do
    if [ -f "/proc/$pid/io" ]; then
        read_bytes=$(grep 'read_bytes' /proc/$pid/io | awk '{print $2}')

        if [ -n "$read_bytes" ] && [ "$read_bytes" -gt 0 ]; then
            cmd_line=$(tr '\0' ' ' < /proc/$pid/cmdline)
            echo "$pid:$cmd_line:$read_bytes" >> "$temp_file"
        fi
    fi
done

sleep 60

for pid in $(ls /proc | egrep '^[0-9]+$'); do
    if [ -f "/proc/$pid/io" ]; then
        read_bytes=$(grep 'read_bytes' /proc/$pid/io | awk '{print $2}')
        prev_read_bytes=$(grep "^$pid:" "$temp_file" | cut -d':' -f3)

        if [ -n "$prev_read_bytes" ] && [ -n "$read_bytes" ]; then
            delta_bytes=$(($read_bytes - $prev_read_bytes))
            cmd_line=$(tr '\0' ' ' < /proc/$pid/cmdline)
            echo "$pid:$cmd_line:$delta_bytes"
        fi
    fi
done | sort -t: -k3,3 -n | head -n 3

rm "$temp_file"
