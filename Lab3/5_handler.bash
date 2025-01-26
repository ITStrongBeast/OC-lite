#!/bin/bash

PIPE_NAME="calc"
CURRENT_MODE="add"
CURRENT_VALUE=1

process_input() {
    local input="$1"
    case "$input" in
        "+")
            CURRENT_MODE="add"
            ;;
        "*")
            CURRENT_MODE="multiply"
            ;;
        "QUIT")
            echo "Завершение работы. Итоговое значение: $CURRENT_VALUE"
            exit 0
            ;;
        ''|*[!0-9]*)
            echo "Ошибка входных данных. Завершение."
            exit 1
            ;;
        *)
            if [[ "$CURRENT_MODE" == "add" ]]; then
                CURRENT_VALUE=$((CURRENT_VALUE + input))
            elif [[ "$CURRENT_MODE" == "multiply" ]]; then
                CURRENT_VALUE=$((CURRENT_VALUE * input))
            fi
            echo "Текущее значение = $CURRENT_VALUE"
            ;;
    esac
}

while read -r line; do
    process_input "$line"
done < "$PIPE_NAME"
