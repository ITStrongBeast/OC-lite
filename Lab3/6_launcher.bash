#!/bin/bash

./6_handler.bash &
PROCESS_PID=$!

./6_producer.bash $PROCESS_PID

wait $PROCESS_PID
