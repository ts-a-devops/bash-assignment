#!/bin/bash

# Ensure logs directory exists
mkdir -p logs
LOG_FILE="logs/file_manager.log"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Show usage if wrong input
if [ $# -lt 1 ]; then
    echo "Usage: $0 {create|delete|list|rename} [file_name] [new_name]"
    exit 1
fi

command=$1

case "$command" in
    create)
        file=$2
        if [ -z "$file" ]; then
            echo "Please specify a file name to create."
            exit 1
        fi
        if [ -e "$file" ]; then
            echo "Error: $file already exists. Won't overwrite."
            exit 1
        fi
        touch "$file"
        echo "File $file created."
        log_action "Created file: $file"
        ;;
        
    delete)
        file=$2
        if [ -z "$file" ]; then
            echo "Please specify a file name to delete."
            exit 1
        fi
        if [ ! -e "$file" ]; then
            echo "Error: $file does not exist."
            exit 1
        fi
        rm "$file"
        echo "File $file deleted."
        log_action "Deleted file: $file"
        ;;
        
    list)
        echo "Files in current directory:"
        ls -1
        log_action "Listed files"
        ;;
        
    rename)
        old_name=$2
        new_name=$3
        if [ -z "$old_name" ] || [ -z "$new_name" ]; then
            echo "Usage: $0 rename old_name new_name"
            exit 1
        fi
        if [ ! -e "$old_name" ]; then
            echo "Error: $old_name does not exist."
            exit 1
        fi
        if [ -e "$new_name" ]; then
            echo "Error: $new_name already exists. Won't overwrite."
            exit 1
        fi
        mv "$old_name" "$new_name"
        echo "Renamed $old_name to $new_name."
        log_action "Renamed $old_name to $new_name"
        ;;
        
    *)
        echo "Unknown command: $command"
        echo "Usage: $0 {create|delete|list|rename} [file_name] [new_name]"
        exit 1
        ;;
esac
