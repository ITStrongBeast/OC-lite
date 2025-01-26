#!/bin/bash

output_file="cpu_burst.txt"


for pid in $(ls /proc | egrep '^[0-9]+$'); do

    if [ ! -d "/proc/$pid" ]; then
        continue
    fi

    ppid=$(ps -o ppid= -p "$pid" | awk '{print $1}')
    sum_exec_runtime=$(grep '^se.sum_exec_runtime' /proc/$pid/sched | awk '{print $3}')
    nr_switches=$(grep '^nr_switches' /proc/$pid/sched | awk '{print $3}')
    
    if [[ "$nr_switches" -gt 0 ]]; then
        art=$(echo "scale=6; $sum_exec_runtime / $nr_switches" | bc)
        echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art"
    fi
done | sort -t: -k2,2 > "$output_file" 
