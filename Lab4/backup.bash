#!/bin/bash

BACKUP_DIR="$HOME"
SOURCE_DIR="$HOME/source"
REPORT_FILE="$HOME/backup-report"
TODAY=$(date +%Y-%m-%d)

LAST_BACKUP=$(find "$BACKUP_DIR" -type d -name "Backup-*" | sort | tail -n 1)
LAST_DATE=""

if [[ -n "$LAST_BACKUP" ]]; then
    LAST_DATE=$(basename "$LAST_BACKUP" | cut -d'-' -f2-)
fi

if [[ -n "$LAST_DATE" ]] && [[ $(date -d "$TODAY" +%s) -lt $(date -d "$LAST_DATE +7 days" +%s) ]]; then
    BACKUP_TARGET="$LAST_BACKUP"
    ACTION="update"
else
    BACKUP_TARGET="$BACKUP_DIR/Backup-$TODAY"
    mkdir "$BACKUP_TARGET"
    echo "Создан новый каталог: $BACKUP_TARGET" >> "$REPORT_FILE"
    ACTION="new"
fi

copy_files() {
    for src_file in "$SOURCE_DIR"/*; do
        [[ -f "$src_file" ]] || continue
        file_name=$(basename "$src_file")
        dest_file="$BACKUP_TARGET/$file_name"

        if [[ ! -f "$dest_file" ]]; then
            cp "$src_file" "$dest_file"
            echo "$file_name" >> "$REPORT_FILE"
        else
            src_size=$(stat --printf="%s" "$src_file")
            dest_size=$(stat --printf="%s" "$dest_file")

            if [[ "$src_size" -ne "$dest_size" ]]; then
                versioned_name="$dest_file.$TODAY"
                mv "$dest_file" "$versioned_name"
                cp "$src_file" "$dest_file"
                echo "$file_name обновлён ($versioned_name)" >> "$REPORT_FILE"
            fi
        fi
    done
}

if [[ "$ACTION" == "new" ]]; then
    echo "Список файлов, скопированных в $BACKUP_TARGET:" >> "$REPORT_FILE"
else
    echo "Обновление каталога $BACKUP_TARGET (дата: $TODAY):" >> "$REPORT_FILE"
fi

copy_files
ls "$BACKUP_TARGET" >> "$REPORT_FILE"
