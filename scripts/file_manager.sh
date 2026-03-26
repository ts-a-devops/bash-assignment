#!/bin/bash

set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

LOGFILE="logs/file_manager.log"

# Function to log actions
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOGFILE"
}

usage() {
    cat << EOF
Usage: $0 <command> [arguments]

Commands:
  create <filename>     Create a new empty file (prevents overwrite)
  delete <filename>     Delete a file
  list [directory]      List files in current or specified directory
  rename <oldname> <newname>  Rename a file

Example:
  ./file_manager.sh create notes.txt
  ./file_manager.sh list
  ./file_manager.sh rename old.txt new.txt
EOF
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No command provided."
    usage
    exit 1
fi

command=$1
shift

case "$command" in
    create)
        if [ $# -eq 0 ]; then
            echo "Error: Filename is required for create."
            usage
            exit 1
        fi
        filename=$1

        if [ -f "$filename" ]; then
            echo "Error: File '$filename' already exists. Overwriting is not allowed."
            log_action "CREATE FAILED - File already exists: $filename"
            exit 1
        fi

        touch "$filename"
        echo "Success: File '$filename' created."
        log_action "CREATE - File created: $filename"
        ;;

    delete)
        if [ $# -eq 0 ]; then
            echo "Error: Filename is required for delete."
            usage
            exit 1
        fi
        filename=$1

        if [ ! -f "$filename" ]; then
            echo "Error: File '$filename' does not exist."
            log_action "DELETE FAILED - File not found: $filename"
            exit 1
        fi

        rm "$filename"
        echo "Success: File '$filename' deleted."
        log_action "DELETE - File deleted: $filename"
        ;;

    list)
        dir="${1:-.}"   # Use current directory if none provided
        if [ ! -d "$dir" ]; then
            echo "Error: Directory '$dir' does not exist."
            log_action "LIST FAILED - Directory not found: $dir"
            exit 1
        fi
        echo "Files in directory '$dir':"
        ls -la "$dir"
        log_action "LIST - Listed directory: $dir"
        ;;

    rename)
        if [ $# -ne 2 ]; then
            echo "Error: Need both old and new filename for rename."
            usage
            exit 1
        fi
        oldname=$1
        newname=$2

        if [ ! -f "$oldname" ]; then
            echo "Error: File '$oldname' does not exist."
            log_action "RENAME FAILED - Old file not found: $oldname"
            exit 1
        fi

        if [ -f "$newname" ]; then
            echo "Error: File '$newname' already exists. Cannot overwrite."
            log_action "RENAME FAILED - New file already exists: $newname"
            exit 1
        fi

        mv "$oldname" "$newname"
        echo "Success: Renamed '$oldname' to '$newname'."
        log_action "RENAME - Renamed: $oldname -> $newname"
        ;;

    *)
        echo "Error: Unknown command '$command'."
        usage
        exit 1
        ;;
esac

echo ""
echo "Action logged to: $LOGFILE"
