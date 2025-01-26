#!/bin/bash

ps -eo pid,stime --sort=stime | sed -n '2p' | awk '{print $1}'
