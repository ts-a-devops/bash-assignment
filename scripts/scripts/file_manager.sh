#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Log file
log_file="logs/file_manager.log"

# Function to log actions
log_action() {
    echo "$(date): $1" >> "$log_file"
}

# Check if command is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {create|delete|list|rename} [filename] [newname]"
    exit 1
fi

command=$1
file=$2
newname=$3

case $command in
    create)
        if [ -z "$file" ]; then
            echo "Error: No filename provided."
            exit 1
        fi
        if [ -e "$file" ]; then
            echo "Error: $file already exists. Will not overwrite."
            log_action "CREATE FAILED: $file already exists."
        else
            touch "$file"
            echo "$file created."
            log_action "CREATED $file"
        fi
        ;;

    delete)
        if [ -z "$file" ]; then
            echo "Error: No filename provided."
            exit 1
        fi
        if [ -e "$file" ]; then
            rm "$file"
            echo "$file deleted."
            log_action "DELETED $file"
        else
            echo "Error: $file does not exist."
            log_action "DELETE FAILED: $file does not exist."
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls
        log_action "LISTED FILES"
        ;;

    rename)
        if [ -z "$file" ] || [ -z "$newname" ]; then
            echo "Usage: $0 rename oldname newname"
            exit 1
        fi
        if [ ! -e "$file" ]; then
            echo "Error: $file does not exist."
            log_action "RENAME FAILED: $file does not exist."
        elif [ -e "$newname" ]; then
            echo "Error: $newname already exists. Cannot overwrite."
            log_action "RENAME FAILED: $newname already exists."
        else
            mv "$file" "$newname"
            echo "$file renamed to $newname."
            log_action "RENAMED $file TO $newname"
        fi
        ;;

    *)
        echo "Invalid command. Use: create, delete, list, rename"
        exit 1
        ;;
esac
