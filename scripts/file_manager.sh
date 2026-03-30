#!/bin/bash
mkdir -p logs
log_file="logs/file_manager.log"

action=$1
file=$2
new_name=$3

log_action() { echo "$(date): $1" | tee -a "$log_file"; }

case $action in
    create)
        if [ -e "$file" ]; then
            log_action "Failed to create: $file already exists."
        else
            touch "$file"
            log_action "Created file: $file"
        fi
        ;;
    delete)
        if [ -e "$file" ]; then
            rm "$file"
            log_action "Deleted file: $file"
        else
            log_action "Failed to delete: $file not found."
        fi
        ;;
    list)
        ls -l
        log_action "Listed directory contents."
        ;;
    rename)
        if [ -e "$file" ] && [ ! -e "$new_name" ]; then
            mv "$file" "$new_name"
            log_action "Renamed $file to $new_name"
        else
            log_action "Rename failed: File doesn't exist or new name is taken."
        fi
        ;;
    *)
        echo "Usage: ./scripts/file_manager.sh {create|delete|list|rename} [filename] [new_filename]"
        ;;
esac
