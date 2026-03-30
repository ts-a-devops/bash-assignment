#!/bin/bash

# Configuration
LOG_FILE="../logs/file_manager.log"
mkdir -p "$(dirname "$LOG_FILE")" # Ensure log directory exists

# --- Helper Functions ---

log_msg() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | tee -a "$LOG_FILE"
}

file_exists() {
    [[ -f "$1" ]]
}

# --- Action Logic ---

do_create() {
    if file_exists "$1"; then
        log_msg "ERROR: File '$1' already exists!"
    else
        touch "$1" && log_msg "SUCCESS: Created $1"
    fi
}

do_delete() {
    if file_exists "$1"; then
        rm "$1" && log_msg "SUCCESS: Deleted $1"
    else
        log_msg "ERROR: '$1' not found!"
    fi
}

do_rename() {
    local old_name=$1
    local new_name=$2
    if file_exists "$old_name"; then
        mv "$old_name" "$new_name" && log_msg "SUCCESS: Renamed $old_name to $new_name"
    else
        log_msg "ERROR: Source file '$old_name' not found!"
    fi
}

# --- Main Execution ---

ACTION=$1
FILE=$2
EXTRA=$3

case "$ACTION" in
    create) do_create "$FILE" ;;
    delete) do_delete "$FILE" ;;
    rename) do_rename "$FILE" "$EXTRA" ;;
    list)   ls -lh | tee -a "$LOG_FILE" ;;
    *)      
        echo "Usage: $0 {create|delete|list|rename} [target] [new_name]"
        exit 1 
        ;;
esac