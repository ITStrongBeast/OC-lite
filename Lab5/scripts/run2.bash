#!/bin/bash

newmem_script="./newmem.bash"
k=10
n=4900000

for ((i = 1; i <= k; i++)); do
    echo "Running iteration $i with N=$n..."
    "$newmem_script" "$n" &
    sleep 1
done

echo "Completed $k executions of $newmem_script with parameter N=$n."

echo "Running with K=30..."

k=30
for ((i = 1; i <= k; i++)); do
    echo "Running iteration $i with N=$n..." 
    "$newmem_script" "$n" &
    sleep 1
done

./find2.bash
