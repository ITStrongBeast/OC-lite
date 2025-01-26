#!/bin/bash

counter=0
array=()
n=$1

while [ $counter -lt $n ]; do
    array+=({1..10})
    ((counter++))
done
