#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Ошибка: Необходимо указать имя файла для удаления."
    exit 1
fi

FILE_NAME="$1"

if [ ! -e "$FILE_NAME" ]; then
    echo "Ошибка: Файл '$FILE_NAME' не существует."
    exit 1
fi

TRASH_DIR="$HOME/.trash"
LOG_FILE="$HOME/.trash.log"

if [ ! -d "$TRASH_DIR" ]; then
    mkdir "$TRASH_DIR" || { echo "Ошибка: Не удалось создать каталог $TRASH_DIR."; exit 1; }
fi

LINK_NAME=$(( $(find "$TRASH_DIR" -type f | wc -l) + 1))
LINK_PATH="$TRASH_DIR/$LINK_NAME"

ln "$FILE_NAME" "$LINK_PATH" || { echo "Ошибка: Не удалось создать жесткую ссылку для $FILE_NAME."; exit 1; }
rm "$FILE_NAME" || { echo "Ошибка: Не удалось удалить файл $FILE_NAME."; rm -f "$LINK_PATH"; exit 1; }

echo "$(realpath "$FILE_NAME") -> $LINK_PATH" >> "$LOG_FILE" || {
    echo "Ошибка: Не удалось записать в лог $LOG_FILE."
    exit 1
}
