#!/bin/bash

home="$HOME"
pwd | grep -q "^$home" && echo "$home" && exit 0
echo "Скрипт запущен не из домашней директории" && exit 1