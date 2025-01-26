#!/bin/bash

(crontab -l; echo "5 * * * 3 $PWD/1_datetime.bash") | crontab -
