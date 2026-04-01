#!/bin/bash

# This script manages files with four commands: create, delete, list, and rename

log_file="logs/file_manager.log"
action=$1   # The command the user types (create, delete, list, rename)
file_name=$2 # The file the user wants to act on

# === USAGE GUIDE ====
# Show instructions if no command was given
if [[ -z "$action" ]]; then
    echo "Usage:"
    echo "  ./file_manager.sh create  <filename>"
    echo "  ./file_manager.sh delete  <filename>"
    echo "  ./file_manager.sh list"
    echo "  ./file_manager.sh rename  <oldname> <newname>"
    exit 1
fi

# === CREATE ====
if [[ "$action" == "create" ]]; then

    # Make sure a filename was provided
    if [[ -z "$file_name" ]]; then
        echo "Error: Please provide a filename."
        echo "Usage: ./file_manager.sh create <filename>"
        exit 1
    fi

    # Prevent overwriting — check if the file already exists
    if [[ -f "$file_name" ]]; then
        echo "Error: '$file_name' already exists. Will not overwrite."
        exit 1
    fi

    # Create the file and log the action
    touch "$file_name"
    echo "Created: $file_name"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Created: $file_name" >> "$log_file"

# ==== DELETE ====
elif [[ "$action" == "delete" ]]; then

    # Make sure a filename was provided
    if [[ -z "$file_name" ]]; then
        echo "Error: Please provide a filename."
        echo "Usage: ./file_manager.sh delete <filename>"
        exit 1
    fi

    # Check if the file exists before trying to delete it
    if [[ ! -f "$file_name" ]]; then
        echo "Error: '$file_name' does not exist."
        exit 1
    fi

    # Delete the file and log the action
    rm "$file_name"
    echo "Deleted: $file_name"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Deleted: $file_name" >> "$log_file"

# === LIST =====
elif [[ "$action" == "list" ]]; then

    # List all files in the current directory and log the action
    echo "Files in current directory:"
    ls -lh
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Listed files in: $(pwd)" >> "$log_file"

# ==== RENAME ====
elif [[ "$action" == "rename" ]]; then

    new_name=$3  # The new filename is the third argument

    # Make sure both old and new names were provided
    if [[ -z "$file_name" || -z "$new_name" ]]; then
        echo "Error: Please provide both old and new filenames."
        echo "Usage: ./file_manager.sh rename <oldname> <newname>"
        exit 1
    fi

    # Check if the file to rename actually exists
    if [[ ! -f "$file_name" ]]; then
        echo "Error: '$file_name' does not exist."
        exit 1
    fi

    # Prevent overwriting — check if the new filename is already taken
    if [[ -f "$new_name" ]]; then
        echo "Error: '$new_name' already exists. Will not overwrite."
        exit 1
    fi

    # Rename the file and log the action
    mv "$file_name" "$new_name"
    echo "Renamed: $file_name  →  $new_name"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Renamed: $file_name to $new_name" >> "$log_file"

# ==== UNKNOWN COMMAND =====
else
    echo "Error: Unknown command '$action'"
    echo "Available commands: create, delete, list, rename"
    exit 1

fi
