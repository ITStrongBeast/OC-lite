#!/bin/bash

CURRENT_VALUE=1 
RUNNING=true
COMMAND_FILE="/tmp/temp_file.$$"

handle_sigterm() {
    echo "Обработчик завершает работу по сигналу TERM."
    RUNNING=false
    rm -f "$COMMAND_FILE"
}

additive_operation() {
    COMMAND=$(cat "$COMMAND_FILE")
    case "$COMMAND" in
        "+") CURRENT_VALUE=$((CURRENT_VALUE + 2)) ;;
        "-") CURRENT_VALUE=$((CURRENT_VALUE - 2)) ;;
    esac
}

multiplicative_operation() {
    COMMAND=$(cat "$COMMAND_FILE")
    case "$COMMAND" in
        "*") CURRENT_VALUE=$((CURRENT_VALUE * 2)) ;;
        "/") CURRENT_VALUE=$((CURRENT_VALUE / 2)) ;;
    esac
}

trap 'additive_operation' USR1
trap 'multiplicative_operation' USR2
trap 'handle_sigterm' SIGTERM

while $RUNNING; do
    echo "Текущее значение: $CURRENT_VALUE"
    sleep 1
done
