#!/bin/bash

output_file="from_sbin.txt"

ps -eo comm,pid | egrep '^/sbin/' | awk '{print $2}' > "$output_file"
