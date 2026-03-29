#!/bin/bash

mkdir -p logs

log_file="logs/file_manager.log"
action=$1
target=$2

if [[ -z "$action" || -z "$target" ]]; then
    echo "Usage: ./file_manager.sh <create|delete|list|rename> <filename>"
    exit 1
fi

case $action in
    create)
        if [[ -f "$target" ]]; then
            echo "Error: $target already exists."
        else
            touch "$target"
            echo "Created: $target"
            echo "$(date): Created $target" >> "$log_file"
        fi
        ;;
    delete)
        if [[ ! -f "$target" ]]; then
            echo "Error: $target does not exist."
        else
            rm "$target"
            echo "Deleted: $target"
            echo "$(date): Deleted $target" >> "$log_file"
        fi
        ;;
    list)
        echo "Files in current directory:"
        ls
        echo "$(date): Listed files" >> "$log_file"
        ;;
    rename)
        new_name=$3
        if [[ -z "$new_name" ]]; then
            echo "Error: Provide a new name."
            exit 1
        fi
        mv "$target" "$new_name"
        echo "Renamed: $target to $new_name"
        echo "$(date): Renamed $target to $new_name" >> "$log_file"
        ;;
    *)
        echo "Unknown command: $action"
        exit 1
        ;;
esac
