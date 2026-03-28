#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Validate input
if [ -z "$1" ]; then
    echo "Usage: ./file_manager.sh <command> <filename>"
    echo "Commands: create, delete, list, rename"
    exit 1
fi

command=$1
filename=$2
newname=$3

case "$command" in
    create)
        if [ -f "$filename" ]; then
            echo "Error: File already exists!"
            echo "$(date): create $filename - failed (exists)" >> logs/file_manager.log
        else
            touch "$filename"
            echo "File created: $filename"
            echo "$(date): create $filename - success" >> logs/file_manager.log
        fi
        ;;

    delete)
        if [ ! -f "$filename" ]; then
            echo "Error: File does not exist!"
        else
            rm "$filename"
            echo "File deleted: $filename"
            echo "$(date): delete $filename - success" >> logs/file_manager.log
        fi
        ;;

    list)
        echo "=== Files in current directory ==="
        ls -l
        echo "$(date): list - success" >> logs/file_manager.log
        ;;

    rename)
        if [ -z "$newname" ]; then
            echo "Usage: ./file_manager.sh rename <oldname> <newname>"
            exit 1
        fi

        if [ ! -f "$filename" ]; then
            echo "Error: File does not exist!"
        else
            mv "$filename" "$newname"
            echo "Renamed $filename to $newname"
            echo "$(date): rename $filename -> $newname - success" >> logs/file_manager.log
        fi
        ;;

    *)
        echo "Invalid command!"
        echo "Commands: create, delete, list, rename"
        ;;
esac
