#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <command> <filename>"
    echo "Commands: create, delete, list, rename"
    echo "Example: $0 create file.txt"
    exit 1
fi

command=$1
filename=$2

case "$command" in
    create)
        if [[ -f "$filename" ]]; then
            echo "Error: File '$filename' already exists. Will not overwrite."
            log_action "FAILED: create $filename (file exists)"
            exit 1
        else
            touch "$filename"
            echo "Created file: $filename"
            log_action "SUCCESS: create $filename"
        fi
        ;;
    delete)
        if [[ -f "$filename" ]]; then
            rm "$filename"
            echo "Deleted file: $filename"
            log_action "SUCCESS: delete $filename"
        else
            echo "Error: File '$filename' does not exist"
            log_action "FAILED: delete $filename (not found)"
            exit 1
        fi
        ;;
    list)
        if [[ -d "$filename" ]]; then
            echo "Contents of directory: $filename"
            ls -la "$filename"
        else
            echo "Contents of current directory:"
            ls -la
        fi
        log_action "SUCCESS: list $filename"
        ;;
    rename)
        if [[ $# -lt 3 ]]; then
            echo "Usage: $0 rename <old_name> <new_name>"
            exit 1
        fi
        new_name=$3
        if [[ ! -f "$filename" ]]; then
            echo "Error: File '$filename' does not exist"
            log_action "FAILED: rename $filename to $new_name (source not found)"
            exit 1
        fi
        if [[ -f "$new_name" ]]; then
            echo "Error: File '$new_name' already exists. Will not overwrite."
            log_action "FAILED: rename $filename to $new_name (target exists)"
            exit 1
        fi
        mv "$filename" "$new_name"
        echo "Renamed '$filename' to '$new_name'"
        log_action "SUCCESS: rename $filename to $new_name"
        ;;
    *)
        echo "Unknown command: $command"
        echo "Valid commands: create, delete, list, rename"
        log_action "FAILED: unknown command $command"
        exit 1
        ;;
esac