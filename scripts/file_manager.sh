#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"

# Ensure logs directory exists
mkdir -p "$LOG_DIR"

# Check that at least two arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 {create|delete|list|rename} filename [newname]"
    exit 1
fi

command=$1
file=$2

case $command in
    create)
        if [ -e "$file" ]; then
            echo "Error: $file already exists." | tee -a "$LOG_FILE"
        else
            touch "$file"
            echo "Created file: $file" | tee -a "$LOG_FILE"
        fi
        ;;
    delete)
        if [ -e "$file" ]; then
            rm "$file"
            echo "Deleted file: $file" | tee -a "$LOG_FILE"
        else
            echo "Error: $file does not exist." | tee -a "$LOG_FILE"
        fi
        ;;
    list)
        echo "Listing files in current directory:" | tee -a "$LOG_FILE"
        ls | tee -a "$LOG_FILE"
        ;;
    rename)
        newname=$3
        if [ -z "$newname" ]; then
            echo "Error: Missing new filename." | tee -a "$LOG_FILE"
            exit 1
        fi
        if [ ! -e "$file" ]; then
            echo "Error: $file does not exist." | tee -a "$LOG_FILE"
        elif [ -e "$newname" ]; then
            echo "Error: $newname already exists." | tee -a "$LOG_FILE"
        else
            mv "$file" "$newname"
            echo "Renamed $file to $newname" | tee -a "$LOG_FILE"
        fi
        ;;
    *)
        echo "Invalid command. Use create, delete, list, or rename." | tee -a "$LOG_FILE"
        ;;
esac

