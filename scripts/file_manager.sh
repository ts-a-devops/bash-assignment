#!/bin/bash

LOG_FILE="logs/file_manager.log"
mkdir -p logs

# enable automatic logging
exec > >(tee -a "$LOG_FILE") 2>&1

# Timestamp 
timestamp() {
    date +"[%Y-%m-%d %H:%M:%S]"
}

command="$1"
arg1="$2"
arg2="$3"

case "$command" in

    create)
        if [[ -z "$arg1" ]]; then
            echo "Error: No filename provided"
            exit 1
        fi

        if [[ -e "$arg1" ]]; then
            echo "Error: File already exists"
            exit 1
        fi

        touch "$arg1"
        echo "File '$arg1' created successfully"
        ;;

    delete)
        if [[ -z "$arg1" ]]; then
            echo "Error: No filename provided"
            exit 1
        fi

        if [[ ! -e "$arg1" ]]; then
            echo "Error: File does not exist"
            exit 1
        fi

        rm "$arg1"
        echo "File '$arg1' deleted successfully"
        ;;

    list)
        echo "Files in current directory:"
        ls -l
        ;;

    rename)
        if [[ -z "$arg1" || -z "$arg2" ]]; then
            echo "Error: Provide old and new filenames"
            exit 1
        fi

        if [[ ! -e "$arg1" ]]; then
            echo "Error: File '$arg1' does not exist"
            exit 1
        fi

        if [[ -e "$arg2" ]]; then
            echo "Error: Cannot overwrite '$arg2'"
            exit 1
        fi

        mv "$arg1" "$arg2"
        echo "Renamed '$arg1' to '$arg2'"
        ;;

    *)
        echo "Usage:"
        echo "./file_manager.sh create <file>"
        echo "./file_manager.sh delete <file>"
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename <old> <new>"
        exit 1
        ;;

esac
