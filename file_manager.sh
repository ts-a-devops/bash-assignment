#!/bin/bash

LOG_FILE="logs/file_manager.log"

function log_action() {
    echo "[32m[$(date -u +'%Y-%m-%d %H:%M:%S')] - $1[0m" | tee -a "$LOG_FILE"
}

function create_file() {
    touch "$1"
    log_action "Created file: $1"
}

function delete_file() {
    rm "$1"
    log_action "Deleted file: $1"
}

function list_files() {
    ls -1
    log_action "Listed files"
}

function rename_file() {
    mv "$1" "$2"
    log_action "Renamed file: $1 to $2"
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
        echo "Usage: $0 {create|delete|list|rename} [file|old_file new_file]"
        exit 1
        ;;
esac
