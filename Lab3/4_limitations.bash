#!/bin/bash

run_loop() {
    while :; do echo $((2 * 3)) > /dev/null; done
}

(run_loop) & PID1=$!; (run_loop) & PID2=$!; (run_loop) & PID3=$!

cpulimit -p $PID1 -l 10 &

kill -SIGTERM $PID3

top -b -n1 -p $PID1,$PID2 | egrep "PID|$PID1|$PID2"

kill -SIGTERM $PID1 $PID2
