#!/bin/bash

BACKUP_DIR="$HOME"
RESTORE_DIR="$HOME/restore"

LATEST_BACKUP=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "Backup-*" | sort | tail -n 1)

if [[ -z "$LATEST_BACKUP" ]]; then
    echo "Ошибка: Не найдено ни одного каталога резервного копирования."
    exit 1
fi

echo "Актуальный каталог резервного копирования: $LATEST_BACKUP"

if [[ ! -d "$RESTORE_DIR" ]]; then
    mkdir -p "$RESTORE_DIR"
    echo "Создан каталог для восстановления: $RESTORE_DIR"
fi

for file in "$LATEST_BACKUP"/*; do
    if [[ -f "$file" && ! "$file" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        cp "$file" "$RESTORE_DIR/"
        echo "Скопирован: $(basename "$file")"
    fi
done
