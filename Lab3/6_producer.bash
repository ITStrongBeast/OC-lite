#!/bin/bash

PROCESSOR_PID=$1
COMMAND_FILE="/tmp/temp_file.$PROCESSOR_PID"

while true; do
    read -r input
    case "$input" in
        "+" | "-") 
            echo "$input" > "$COMMAND_FILE"
            kill -USR1 "$PROCESSOR_PID" 
            ;;
        "*" | "/") 
            echo "$input" > "$COMMAND_FILE"
            kill -USR2 "$PROCESSOR_PID" 
            ;;
        "TERM")
            kill -SIGTERM "$PROCESSOR_PID"
            exit 0
            ;;
        *) echo "Неизвестная команда: $input" ;;
    esac
done
