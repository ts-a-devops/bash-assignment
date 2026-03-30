#!/bin/bash

# Create logs directory
mkdir -p logs

LOG_FILE="logs/file_manager.log"

# Get command and filename
action=$1
filename=$2
newname=$3

case $action in

    create)
        if [[ -f $filename ]]; then
            echo "File already exists"
        else
            touch $filename
            echo "$(date): Created $filename" >> $LOG_FILE
            echo "File created: $filename"
        fi
        ;;

    delete)
        if [[ -f $filename ]]; then
            rm $filename
            echo "$(date): Deleted $filename" >> $LOG_FILE
            echo "File deleted: $filename"
        else
            echo "File does not exist"
        fi
        ;;

    list)
        ls
        ;;

    rename)
        if [[ -f $filename ]]; then
            mv $filename $newname
            echo "$(date): Renamed $filename to $newname" >> $LOG_FILE
            echo "File renamed"
        else
            echo "File does not exist"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename} filename"
        ;;
esac

