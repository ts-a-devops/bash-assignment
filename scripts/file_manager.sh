#!/bin/bash

LOG_FILE="logs/file_manager.log"
mkdir -p logs

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Get command and arguments
command=$1
file1=$2
file2=$3

case $command in

    create)
        if [ -z "$file1" ]; then
            echo "Error: No file name provided"
        elif [ -e "$file1" ]; then
            echo "Error: File already exists"
            log "CREATE FAILED: $file1 already exists"
        else
            touch "$file1"
            echo "File created: $file1"
            log "CREATED: $file1"
        fi
        ;;

    delete)
        if [ -z "$file1" ]; then
            echo "Error: No file name provided"
        elif [ ! -e "$file1" ]; then
            echo "Error: File does not exist"
            log "DELETE FAILED: $file1 not found"
        else
            rm "$file1"
            echo "File deleted: $file1"
            log "DELETED: $file1"
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls
        log "LISTED files"
        ;;

    rename)
        if [ -z "$file1" ] || [ -z "$file2" ]; then
            echo "Error: Provide old and new file names"
        elif [ ! -e "$file1" ]; then
            echo "Error: File does not exist"
            log "RENAME FAILED: $file1 not found"
        elif [ -e "$file2" ]; then
            echo "Error: Target file already exists"
            log "RENAME FAILED: $file2 already exists"
        else
            mv "$file1" "$file2"
            echo "Renamed $file1 to $file2"
            log "RENAMED: $file1 -> $file2"
        fi
        ;;

    *)
        echo "Usage:"
        echo "./file_manager.sh create filename"
        echo "./file_manager.sh delete filename"
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename oldname newname"
        ;;
esac
