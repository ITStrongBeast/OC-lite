#!/bin/bash

DURATION=300
TEMP_FILE="temp_file.txt"
MAX_COUNT=5

> $TEMP_FILE 
END_TIME=$(( $(date +%s) + DURATION ))
while [ $(date +%s) -lt $END_TIME ]; do
    ps -eo pid=,user=,state=,vsz=,cmd= --no-headers --delimiter='|' | awk -F'|' '$3=="R"' >> $TEMP_FILE
    sleep 5
done

awk -F'|' '!seen[$1]++' $TEMP_FILE > initial_data.txt

printf "%-10s %-10s %-50s %s\n" "PID" "UID" "COMMAND" "VSZ_PERCENT_DIFF"

count=0
while IFS='|' read -r pid user state vsz cmd; do
    if ps -p $pid > /dev/null; then
        curr_data=$(ps -p $pid -o pid=,user=,state=,vsz=,cmd= --no-headers --delimiter='|')
        IFS='|' read -r curr_pid curr_user curr_state curr_vsz curr_cmd <<< "$curr_data"
        
        if [ "$curr_state" == "S" ] && [ $vsz -ne 0 ]; then
            vsz_percent_diff=$(echo "scale=2; (($curr_vsz - $vsz) / $vsz) * 100" | bc)
            printf "%-10s %-10s %-50s %s%%\n" "$pid" "$user" "$cmd" "$vsz_percent_diff"
            count=$((count + 1))
            [ $count -ge $MAX_COUNT ] && break
        fi
    fi
done < initial_data.txt
