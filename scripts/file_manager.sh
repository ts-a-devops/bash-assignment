#!/bin/bash
set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

logfile="logs/file_manager.log"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$logfile"
}

# Function to display usage
usage() {
    echo "Usage: $0 <command> <argument>"
    echo "Commands:"
    echo "  create <filename>   - Create a new file"
    echo "  delete <filename>   - Delete a file"
    echo "  list [directory]    - List files (default: current directory)"
    echo "  rename <old> <new>  - Rename a file"
    exit 1
}

# Check if at least command is provided
if [[ $# -lt 1 ]]; then
    usage
fi

command="$1"

case "$command" in
    create)
        if [[ $# -ne 2 ]]; then
            echo "Error: 'create' requires a filename" >&2
            usage
        fi
        filename="$2"
        
        if [[ -e "$filename" ]]; then
            echo "Error: File '$filename' already exists. Not overwriting." >&2
            log_action "FAILED: create $filename - File already exists"
            exit 1
        fi
        
        touch "$filename"
        echo "Created: $filename"
        log_action "SUCCESS: create $filename"
        ;;
    
    delete)
        if [[ $# -ne 2 ]]; then
            echo "Error: 'delete' requires a filename" >&2
            usage
        fi
        filename="$2"
        
        if [[ ! -f "$filename" ]]; then
            echo "Error: File '$filename' does not exist" >&2
            log_action "FAILED: delete $filename - File not found"
            exit 1
        fi
        
        rm "$filename"
        echo "Deleted: $filename"
        log_action "SUCCESS: delete $filename"
        ;;
    
    list)
        target="${2:-.}"
        
        if [[ ! -d "$target" ]]; then
            echo "Error: Directory '$target' does not exist" >&2
            log_action "FAILED: list $target - Directory not found"
            exit 1
        fi
        
        echo "Listing files in: $target"
        ls -la "$target"
        log_action "SUCCESS: list $target"
        ;;
    
    rename)
        if [[ $# -ne 3 ]]; then
            echo "Error: 'rename' requires old and new filename" >&2
            usage
        fi
        oldname="$2"
        newname="$3"
        
        if [[ ! -f "$oldname" ]]; then
            echo "Error: File '$oldname' does not exist" >&2
            log_action "FAILED: rename $oldname to $newname - Source not found"
            exit 1
        fi
        
        if [[ -e "$newname" ]]; then
            echo "Error: Target '$newname' already exists. Not overwriting." >&2
            log_action "FAILED: rename $oldname to $newname - Target exists"
            exit 1
        fi
        
        mv "$oldname" "$newname"
        echo "Renamed: $oldname -> $newname"
        log_action "SUCCESS: rename $oldname to $newname"
        ;;
    
    *)
        echo "Error: Unknown command '$command'" >&2
        usage
        ;;
esac
