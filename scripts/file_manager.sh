#!/bin/bash

LOG_FILE="logs/file_manager.log"

ACTION=${1:-}
FILE1=${2:-}
FILE2=${3:-}

log(){
    echo "$(date): $1" >> "$LOG_FILE"
}

case "$ACTION" in

    create)
        if [[ -z "$FILES1" ]]; then
            echo "Usage: $0 create <filename>"
            exit 1
        fi

        if [[ -e "$FILE1" ]]; then
            echo "Error: File already exists."
            log "FAILED create $FILE1 (exists)"
            exit 1
        fi

        touch "$FILE1"
        echo "File created: $FILE1"
        LOG "Created file $FILE1"
        ;;

   delete)
        if [[ -z "$FILE1" ]]; then
            echo "Usage: $0 delete <filename>"
            exit 1
        fi

        if [[ ! -e "$FILE1" ]]; then
            echo  "Error: File not found."
            log "FAILED delete $FILE1 (not found)"
            exit 1
        fi

        rm "$FILE1"
        echo "File deleted: $FILE1"
        log "Deleted file $FILE1"
        ;;

   list)
       echo "File in current directory:"
       ls -l
       log "Listed files"
       ;;

   rename)
    if [[ -z "$FILE1" || -z "$FILE2" ]]; then
        echo "Usage: $0 rename <old> <new>"
        exit 1
    fi

    if [[ ! -e "$FILE1" ]]; then
        echo "Error: Source file not found."
        exit 1
    fi

    mv "$FILE1" "$FILE2"
    echo "Renamed $FILE1 → $FILE2"
    ;;

   *)
         echo "Invalid command."
         echo "Usage: $0 {create|delete|listrename}"
         ;;
esac
