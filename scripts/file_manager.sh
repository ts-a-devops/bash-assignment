#!/bin/bash
# This is the File Manager script

mkdir -p logs

if [ $# -lt 1 ]; then
    echo "How to use:"
    echo "./file_manager.sh create filename.txt"
    echo "./file_manager.sh delete filename.txt"
    echo "./file_manager.sh list"
    echo "./file_manager.sh rename old.txt new.txt"
    exit 1
fi

action=$1
file=$2
newfile=$3

# Function to write to log
log() {
    echo "$(date) - $1" >> logs/file_manager.log
}

case $action in
    create)
        if [ -f "$file" ]; then
            echo "File already exists! I will not overwrite it."
            log "CREATE failed - $file already exists"
        else
            touch "$file"
            echo "File '$file' created."
            log "CREATE - $file"
        fi
        ;;

    delete)
        if [ -f "$file" ]; then
            rm "$file"
            echo "File '$file' deleted."
            log "DELETE - $file"
        else
            echo "File '$file' not found."
        fi
        ;;

    list)
        echo "Files in this folder:"
        ls -lh
        log "LIST - files shown"
        ;;

    rename)
        if [ -z "$newfile" ]; then
            echo "Please give new name: ./file_manager.sh rename old.txt new.txt"
        elif [ -f "$file" ]; then
            mv "$file" "$newfile"
            echo "Renamed '$file' to '$newfile'"
            log "RENAME - $file → $newfile"
        else
            echo "File '$file' not found."
        fi
        ;;

    *)
        echo "Unknown command. Use: create, delete, list, rename"
        ;;
esac