#!/bin/bash

a=$1; b=$2; result=0

for ((i=$a; i<=$b; i++))
do
	let result=$((result+i))
	echo $result
done