#!/bin/bash

mkdir -p logs

LOG_FILE="logs/file_manager.log"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 {create|delete|list|rename} [filename]"
    exit 1
fi

COMMAND=$1

case $COMMAND in

    create)
        FILE=$2
        if [[ -z "$FILE" ]]; then
            log "ERROR: No filename provided for create."
            exit 1
        fi

        if [[ -e "$FILE" ]]; then
            log "ERROR: File '$FILE' already exists. Cannot overwrite."
        else
            touch "$FILE"
            log "SUCCESS: File '$FILE' created."
        fi
        ;;

    delete)
        FILE=$2
        if [[ -z "$FILE" ]]; then
            log "ERROR: No filename provided for delete."
            exit 1
        fi

        if [[ -e "$FILE" ]]; then
            rm "$FILE"
            log "SUCCESS: File '$FILE' deleted."
        else
            log "ERROR: File '$FILE' does not exist."
        fi
        ;;

    list)
        log "Listing files in current directory:"
        ls -lh | tee -a "$LOG_FILE"
        ;;

    rename)
        OLD_NAME=$2
        NEW_NAME=$3

        if [[ -z "$OLD_NAME" || -z "$NEW_NAME" ]]; then
            log "ERROR: Usage: $0 rename old_filename new_filename"
            exit 1
        fi

        if [[ ! -e "$OLD_NAME" ]]; then
            log "ERROR: File '$OLD_NAME' does not exist."
        elif [[ -e "$NEW_NAME" ]]; then
            log "ERROR: Target file '$NEW_NAME' already exists."
        else
            mv "$OLD_NAME" "$NEW_NAME"
            log "SUCCESS: '$OLD_NAME' renamed to '$NEW_NAME'."
        fi
        ;;

    *)
        log "ERROR: Invalid command. Use create, delete, list, or rename."
        exit 1
        ;;

esac
