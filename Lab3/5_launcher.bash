#!/bin/bash

PIPE_NAME="calc"
[ -p "$PIPE_NAME" ] || mkfifo "$PIPE_NAME"

./5_handler.bash &
PROCESS_PID=$!

./5_producer.bash

wait $PROCESS_PID
rm -f "$PIPE_NAME"
