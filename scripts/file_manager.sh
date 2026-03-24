#!/bin/bash
set -euo pipefail

mkdir -p logs

LOG_FILE="logs/file_manager.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

usage() {
    echo "Usage: $0 {create|delete|list|rename} [arguments]"
    exit 1
}

# Validate arguments
if [[ $# -lt 1 ]]; then
    usage
fi

COMMAND=$1
shift

case "$COMMAND" in
    create)
        if [[ $# -lt 1 ]]; then
            echo "Error: Filename required"
            exit 1
        fi
        filename=$1
        if [[ -e "$filename" ]]; then
            echo "Error: File '$filename' already exists"
            log "FAILED: Create '$filename' - file already exists"
            exit 1
        fi
        touch "$filename"
        echo "Created: $filename"
        log "CREATED: $filename"
        ;;
    
    delete)
        if [[ $# -lt 1 ]]; then
            echo "Error: Filename required"
            exit 1
        fi
        filename=$1
        if [[ ! -e "$filename" ]]; then
            echo "Error: File '$filename' not found"
            log "FAILED: Delete '$filename' - file not found"
            exit 1
        fi
        rm "$filename"
        echo "Deleted: $filename"
        log "DELETED: $filename"
        ;;
    
    list)
        if [[ $# -eq 0 ]]; then
            ls -la
            log "LISTED: current directory"
        else
            if [[ -d "$1" ]]; then
                ls -la "$1"
                log "LISTED: directory '$1'"
            else
                echo "Error: Directory '$1' not found"
                log "FAILED: List '$1' - directory not found"
                exit 1
            fi
        fi
        ;;
    
    rename)
        if [[ $# -lt 2 ]]; then
            echo "Error: Source and destination filenames required"
            exit 1
        fi
        source=$1
        dest=$2
        if [[ ! -e "$source" ]]; then
            echo "Error: Source file '$source' not found"
            log "FAILED: Rename '$source' to '$dest' - source not found"
            exit 1
        fi
        if [[ -e "$dest" ]]; then
            echo "Error: Destination file '$dest' already exists"
            log "FAILED: Rename '$source' to '$dest' - destination exists"
            exit 1
        fi
        mv "$source" "$dest"
        echo "Renamed: $source -> $dest"
        log "RENAMED: $source -> $dest"
        ;;
    
    *)
        usage
        ;;
esac
