#!/bin/bash

PIPE_NAME="calc"

send_to_processor() {
    while true; do
        read -r input
        echo "$input" > "$PIPE_NAME"
        [[ "$input" == "QUIT" ]] && break
    done
}

send_to_processor
