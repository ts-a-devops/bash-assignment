#!/bin/bash

# Create logs folder
mkdir logs 2>/dev/null

LOG_FILE="logs/file_manager.log"

# Get command and argument
command=$1
file=$2
new_name=$3

# Check if command is provided
if [ -z "$command" ]; then
    echo "Usage: $0 {create|delete|list|rename} filename [new_name]"
    exit 1
fi

# CREATE FILE
if [ "$command" = "create" ]; then
    if [ -z "$file" ]; then
        echo "Error: No filename provided."
        exit 1
    fi

    if [ -f "$file" ]; then
        echo "Error: File already exists."
    else
        touch "$file"
        echo "File '$file' created."
        echo "$(date): Created $file" >> "$LOG_FILE"
    fi
fi

# DELETE FILE
if [ "$command" = "delete" ]; then
    if [ -z "$file" ]; then
        echo "Error: No filename provided."
        exit 1
    fi

    if [ -f "$file" ]; then
        rm "$file"
        echo "File '$file' deleted."
        echo "$(date): Deleted $file" >> "$LOG_FILE"
    else
        echo "Error: File does not exist."
    fi
fi

# LIST FILES
if [ "$command" = "list" ]; then
    ls
    echo "$(date): Listed files" >> "$LOG_FILE"
fi

# RENAME FILE
if [ "$command" = "rename" ]; then
    if [ -z "$file" ] || [ -z "$new_name" ]; then
        echo "Error: Provide old and new filename."
        exit 1
    fi

    if [ ! -f "$file" ]; then
        echo "Error: File does not exist."
    elif [ -f "$new_name" ]; then
        echo "Error: New filename already exists."
    else
        mv "$file" "$new_name"
        echo "File renamed to '$new_name'."
        echo "$(date): Renamed $file to $new_name" >> "$LOG_FILE"
    fi
fi