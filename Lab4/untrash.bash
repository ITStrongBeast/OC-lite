#!/bin/bash

conflict_policy="ignore"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--ignore) conflict_policy="ignore"; shift ;;
        -u|--unique) conflict_policy="unique"; shift ;;
        -o|--overwrite) conflict_policy="overwrite"; shift ;;
        -*) echo "Неизвестный параметр: $1";;
        *) [[ -z "$file_name" ]] && file_name="$1"; shift ;;
    esac
done

[[ -z "$file_name" ]] && echo "Ошибка: Имя файла обязательно." && exit 1

trash_dir="$HOME/.trash"
log_file="$HOME/.trash.log"

[[ ! -f "$log_file" ]] && echo "Ошибка: Лог-файл $log_file не найден." && exit 1

matches=( $(grep ".*${file_name}$" "$log_file") )
[[ ${#matches[@]} -eq 0 ]] && echo "Ошибка: Записи для файла '$file_name' не найдены." && exit 1

for match in "${matches[@]}"; do
    orig_path=$(echo "$match" | cut -d' ' -f1)
    link_path=$(echo "$match" | cut -d' ' -f3)

    echo "Найден файл: $orig_path"
    read -p "Восстановить этот файл? [y/N]: " answer
    [[ "$answer" != "n" && "$answer" != "N" ]] && continue

    target_dir=$(dirname "$orig_path")
    [[ ! -d "$target_dir" ]] && echo "Каталог $target_dir не найден. Восстановление в $HOME." && target_dir="$HOME"

    target_file="$target_dir/$(basename "$orig_path")"

    if [[ -f "$target_file" ]]; then
        case "$conflict_policy" in
            "ignore") echo "Ошибка: $target_file уже существует. Пропуск."; continue ;;
            "unique") 
                base="${target_file%.*}"
                ext="${target_file##*.}"
                version=1
                while [[ -f "${base}(${version}).${ext}" ]]; do ((version++)); done
                target_file="${base}(${version}).${ext}"
                ;;
            "overwrite") echo "Предупреждение: $target_file будет перезаписан." ;;
        esac
    fi

    if ln "$link_path" "$target_file"; then
        echo "Файл восстановлен в $target_file"
        rm "$link_path"
        sed -i "\|$link_path|s|$| # MARKED|" "$log_file"
    else
        echo "Ошибка: Не удалось восстановить $file_name."
    fi
done
