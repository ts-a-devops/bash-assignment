#!/bin/bash

logfile=~/bash-assignment/logs/file_manager.log
action=$1
filename=$2

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$logfile"
}

case $action in
    create)
        if [ -z "$filename" ]; then
            echo "Error: Please provide a filename."
            exit 1
        fi
        if [ -e "$filename" ]; then
            echo "Error: File '$filename' already exists."
        else
            touch "$filename"
            echo "File '$filename' created."
            log_action "CREATED: $filename"
        fi
        ;;
    delete)
        if [ ! -e "$filename" ]; then
            echo "Error: File '$filename' not found."
        else
            rm "$filename"
            echo "File '$filename' deleted."
            log_action "DELETED: $filename"
        fi
        ;;
    list)
        echo "=== Files in current directory ==="
        ls -lh
        log_action "LISTED directory"
        ;;
    rename)
        newname=$3
        if [ ! -e "$filename" ]; then
            echo "Error: File '$filename' not found."
        else
            mv "$filename" "$newname"
            echo "Renamed '$filename' to '$newname'."
            log_action "RENAMED: $filename to $newname"
        fi
        ;;
    *)
        echo "Usage: ./file_manager.sh [create|delete|list|rename] [filename]"
        ;;
esac
