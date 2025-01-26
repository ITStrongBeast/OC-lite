#!/bin/bash

max_mem=0
max_pid=0

for pid in $(ls /proc | egrep '^[0-9]+$'); do
	
	if [ -f "/proc/$pid/status" ]; then
		continue
	fi

	new_mem=$(grep VmSize /proc/$pid/status | awk '{print $2}')
	if [[ $new_mem -gt $max_mem ]]; then
		max_mem=$new_mem
		max_pid=$pid
	fi
done

echo "По данным из /proc: PID=$max_pid"

max_pid=$(top -b -o "+VIRT" -n 1 | head -n 8 | tail -n 1 | awk '{print $1}')

echo "По данным из top: PID=$max_pid"
