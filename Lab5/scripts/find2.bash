#!/bin/bash

start=20000
end=15000000
K=30

while (( start < end )); do
  N=$(( (start + end) / 2 ))

  for (( i=0; i<K; i++ )); do
    ../newmem.bash "$N" &
    sleep 1
  done

  if dmesg | grep -q "newmem.bash"; then
    end=$(( N - 1 ))
  else
    start=$(( N + 1 ))
  fi

done

result=$(( (start + end) / 2 ))
echo "N = $result"
