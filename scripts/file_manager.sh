#!/bin/bash

LOG_FILE="logs/file_manager.log"

action=$1
file=$2
newname=$3

case $action in
    create)
        if [[ -z "$file" ]]; then
            echo "Usage: create <filename>"
            exit 1
        fi

        if [[ -e "$file" ]]; then
            echo "Error: File already exists."
        else
            touch "$file"
            echo "File created: $file"
            echo "$(date): Created $file" >> "$LOG_FILE"
        fi
        ;;

    delete)
        if [[ -f "$file" ]]; then
            rm "$file"
            echo "File deleted: $file"
            echo "$(date): Deleted $file" >> "$LOG_FILE"
        else
            echo "Error: File not found."
        fi
        ;;

    list)
        ls -l
        ;;

    rename)
        if [[ -z "$file" || -z "$newname" ]]; then
            echo "Usage: rename <oldname> <newname>"
            exit 1
        fi

        if [[ ! -f "$file" ]]; then
            echo "Error: File not found."
        elif [[ -e "$newname" ]]; then
            echo "Error: Target file already exists."
        else
            mv "$file" "$newname"
            echo "Renamed $file to $newname"
            echo "$(date): Renamed $file to $newname" >> "$LOG_FILE"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename} filename [newname]"
        ;;
esac
