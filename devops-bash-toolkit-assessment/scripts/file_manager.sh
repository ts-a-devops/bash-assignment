#!/usr/bin/env bash

LOG_FILE="logs/file_manager.log"

# Ensure logs directory exists or create it
mkdir -p logs

# Function to log actions
log_action() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Check if at least one argument is passed or not
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 {create|delete|list|rename} [filename]"
    exit 1
fi

command=$1

case "$command" in

    create)
        file=$2

        if [[ -z "$file" ]]; then
            echo "Error: No filename provided."
            exit 1
        fi

        if [[ -e "$file" ]]; then
            echo "Error: File already exists. Cannot overwrite."
            log_action "CREATE FAILED: $file already exists"
            exit 1
        fi

        touch "$file"
        echo "File '$file' created successfully."
        log_action "CREATED: $file"
        ;;

    delete)
        file=$2

        if [[ -z "$file" ]]; then
            echo "Error: No filename provided."
            exit 1
        fi

        if [[ ! -e "$file" ]]; then
            echo "Error: File does not exist."
            log_action "DELETE FAILED: $file not found"
            exit 1
        fi

        rm "$file"
        echo "File '$file' deleted."
        log_action "DELETED: $file"
        ;;

    list)
        echo "Files in current directory:"
        ls -lh
        log_action "LISTED files"
        ;;

    rename)
        old_name=$2
        new_name=$3

        if [[ -z "$old_name" || -z "$new_name" ]]; then
            echo "Error: Provide old and new filename."
            exit 1
        fi

        if [[ ! -e "$old_name" ]]; then
            echo "Error: File '$old_name' does not exist."
            log_action "RENAME FAILED: $old_name not found"
            exit 1
        fi

        if [[ -e "$new_name" ]]; then
            echo "Error: '$new_name' already exists. Cannot overwrite."
            log_action "RENAME FAILED: $new_name already exists"
            exit 1
        fi

        mv "$old_name" "$new_name"
        echo "Renamed '$old_name' to '$new_name'."
        log_action "RENAMED: $old_name -> $new_name"
        ;;

    *)
        echo "Invalid command. Use: create | delete | list | rename"
        exit 1
        ;;

esac