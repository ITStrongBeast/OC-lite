#!/bin/bash

cut -d':' -f1,3 /etc/passwd | awk -F':' '{print $2, $1}' | sort -n