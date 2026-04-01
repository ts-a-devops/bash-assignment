#!/bin/bash

mkdir -p logs
LOG_FILE="logs/file_manager.log"

action=$1

case $action in
    create)
        file=$2
        if [ -f "$file" ]; then
            echo "File already exists"
        else
            touch "$file"
            echo "Created $file"
            echo "$(date): Created $file" >> $LOG_FILE
        fi
        ;;
        
    delete)
        file=$2
        if [ -f "$file" ]; then
            rm "$file"
            echo "Deleted $file"
            echo "$(date): Deleted $file" >> $LOG_FILE
        else
            echo "File not found"
        fi
        ;;
        
    list)
        ls
        ;;
        
    rename)
        old=$2
        new=$3
        if [ -f "$old" ]; then
            mv "$old" "$new"
            echo "Renamed $old to $new"
            echo "$(date): Renamed $old to $new" >> $LOG_FILE
        else
            echo "File not found"
        fi
        ;;
        
    *)
        echo "Usage: $0 {create|delete|list|rename}"
        ;;
esac
