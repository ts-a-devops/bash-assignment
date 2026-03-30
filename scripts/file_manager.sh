#!/bin/bash

# File Manager Script
# Supports: create, delete, list, rename

# Log file
log_file="../logs/file_manager.log"

# Create logs directory if it doesn't exist
mkdir -p ../logs

# Get the command and arguments
command=$1
filename=$2
newname=$3

# Function to log actions
log_action() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" >> "$log_file"
}

# Check if command is provided
if [ -z "$command" ]; then
    echo "Usage: ./file_manager.sh <command> [filename] [newname]"
    echo "Commands: create, delete, list, rename"
    echo "Example: ./file_manager.sh create myfile.txt"
    exit 1
fi

# Handle the commands
if [ "$command" = "create" ]; then
    # Check if filename is provided
    if [ -z "$filename" ]; then
        echo "Error: Please provide a filename"
        echo "Usage: ./file_manager.sh create <filename>"
        exit 1
    fi
    
    # Check if file already exists
    if [ -f "$filename" ]; then
        echo "Error: File '$filename' already exists. Cannot overwrite."
        log_action "FAILED: Attempted to create '$filename' but file already exists"
        exit 1
    fi
    
    # Create the file
    touch "$filename"
    echo "File '$filename' created successfully"
    log_action "Created file: $filename"

elif [ "$command" = "delete" ]; then
    # Check if filename is provided
    if [ -z "$filename" ]; then
        echo "Error: Please provide a filename"
        echo "Usage: ./file_manager.sh delete <filename>"
        exit 1
    fi
    
    # Check if file exists
    if [ ! -f "$filename" ]; then
        echo "Error: File '$filename' does not exist"
        log_action "FAILED: Attempted to delete '$filename' but file does not exist"
        exit 1
    fi
    
    # Delete the file
    rm "$filename"
    echo "File '$filename' deleted successfully"
    log_action "Deleted file: $filename"

elif [ "$command" = "list" ]; then
    # List files in current directory
    echo "Files in current directory:"
    ls -la
    log_action "Listed files in directory"

elif [ "$command" = "rename" ]; then
    # Check if both filenames are provided
    if [ -z "$filename" ] || [ -z "$newname" ]; then
        echo "Error: Please provide both filenames"
        echo "Usage: ./file_manager.sh rename <oldname> <newname>"
        exit 1
    fi
    
    # Check if old file exists
    if [ ! -f "$filename" ]; then
        echo "Error: File '$filename' does not exist"
        log_action "FAILED: Attempted to rename '$filename' but file does not exist"
        exit 1
    fi
    
    # Check if new filename already exists
    if [ -f "$newname" ]; then
        echo "Error: File '$newname' already exists. Cannot overwrite."
        log_action "FAILED: Attempted to rename '$filename' to '$newname' but '$newname' already exists"
        exit 1
    fi
    
    # Rename the file
    mv "$filename" "$newname"
    echo "File '$filename' renamed to '$newname' successfully"
    log_action "Renamed file: $filename -> $newname"

else
    echo "Error: Unknown command '$command'"
    echo "Available commands: create, delete, list, rename"
    log_action "FAILED: Unknown command '$command'"
    exit 1
fi
