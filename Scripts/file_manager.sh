#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

create_file() {
    local file=$1

    if [[ -z "$file" ]]; then
        echo "Error: No filename provided"
        return 1
    fi

    if [[ -f "$file" ]]; then
        echo "Blocked: File '$file' already exists"
        log_action "CREATE FAILED - $file already exists"
        return 1
    fi

    touch "$file"
    echo "Created: $file"
    log_action "CREATE SUCCESS - $file created"
}

delete_file() {
    local file=$1

    if [[ -z "$file" ]]; then
        echo "Error: No filename provided"
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        echo "Blocked: File '$file' does not exist"
        log_action "DELETE FAILED - $file not found"
        return 1
    fi

    rm "$file"
    echo "Deleted: $file"
    log_action "DELETE SUCCESS - $file removed"
}

list_files() {
    echo "Current directory file listing:"
    ls -lh
    log_action "LIST EXECUTED"
}

rename_file() {
    local old_name=$1
    local new_name=$2

    if [[ -z "$old_name" || -z "$new_name" ]]; then
        echo "Error: Provide old and new filenames"
        return 1
    fi

    if [[ ! -f "$old_name" ]]; then
        echo "Blocked: Source file does not exist"
        log_action "RENAME FAILED - $old_name not found"
        return 1
    fi

    if [[ -f "$new_name" ]]; then
        echo "Blocked: Target file already exists"
        log_action "RENAME FAILED - $new_name already exists"
        return 1
    fi

    mv "$old_name" "$new_name"
    echo "Renamed: $old_name -> $new_name"
    log_action "RENAME SUCCESS - $old_name to $new_name"
}

case "$1" in
    create)
        create_file "$2"
        ;;
    delete)
        delete_file "$2"
        ;;
    list)
        list_files
        ;;
    rename)
        rename_file "$2" "$3"
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename}"
        exit 1
        ;;
esac
