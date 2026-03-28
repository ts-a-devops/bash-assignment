#!/bin/bash

#save output to: logs/file_manager.log
LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/file_manger.log"
mkdir -p "$LOG_DIR"

#to provide atleast two argumenets
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <command> <filename>"
    echo "Commands: create, delete, list, rename"
    exit 1
fi

COMMAND="$1"
FILE="$2"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

case "$COMMAND" in
#check if file exists before creating
    create)
        if [[ -f "$FILE" ]]; then
            echo "Error: $FILE already exists."
        else
            touch "$FILE"
            echo "File $FILE created."
            echo "$DATE - CREATE - $FILE" >> "$LOG_FILE"
        fi
        ;;
#delete file if it exists
    delete)
        if [[ -f "$FILE" ]]; then
            rm "$FILE"
            echo "Deleted: $FILE"
            echo "$DATE - DELETE - $FILE" >> "$LOG_FILE"
        else
            echo "Error: $FILE does not exist."
        fi
        ;;
#list files
    list)
        ls -l
        echo "$DATE - LIST - $FILE" >> "$LOG_FILE"
        ;;
#check if file already exists before renaming
    rename)
        if [[ -z "$3" ]]; then
            echo "Usage: $0 rename <old_filename> <new_filename>"
            exit 1
        fi
        if [[ -e "$3" ]]; then
            echo "Error: $3 already exists."
            exit 1
        fi
        if [[ -f "$FILE" ]]; then
            mv "$FILE" "$3"
            echo "Renamed: $FILE to $3"
            echo "$DATE - RENAME - $FILE to $3" >> "$LOG_FILE"
        else
            echo "Error: $FILE does not exist."
        fi
        ;;
    *)
        echo "Invalid command. Use: create, delete, list, rename"
        ;;
esac
