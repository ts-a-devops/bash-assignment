#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Check if a command was provided
if [ -z "$1" ]; then
    echo "Usage: ./file_manager.sh <command> <filename>"
    echo "Commands: create, delete, list, rename"
    exit 1
fi

command=$1
filename=$2

# Create a file
if [ "$command" == "create" ]; then
    if [ -f "$filename" ]; then
        echo "Error: File $filename already exists!"
        echo "create $filename - already exists" >> logs/file_manager.log
    else
        touch "$filename"
        echo "File $filename created!"
        echo "create $filename - success" >> logs/file_manager.log
    fi

# Delete a file
elif [ "$command" == "delete" ]; then
    if [ ! -f "$filename" ]; then
        echo "Error: File $filename does not exist!"
    else
        rm "$filename"
        echo "File $filename deleted!"
        echo "delete $filename - success" >> logs/file_manager.log
    fi

# List files
elif [ "$command" == "list" ]; then
    echo "=== Files in current directory ==="
    ls -l
    echo "list - success" >> logs/file_manager.log

# Rename a file
elif [ "$command" == "rename" ]; then
    if [ -z "$3" ]; then
        echo "Usage: ./file_manager.sh rename <oldname> <newname>"
        exit 1
    fi
    mv "$filename" "$3"
    echo "File $filename renamed to $3!"
    echo "rename $filename to $3 - success" >> logs/file_manager.log

else
    echo "Error: Unknown command $command"
    echo "Commands: create, delete, list, rename"
fi
