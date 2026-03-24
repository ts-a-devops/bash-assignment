#!/bin/bash

log_file="logs/file_manager.log"

command=$1
arg1=$2
arg2=$3

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

case "$command" in
    create)
        if [[ -z "$arg1" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi

        if [[ -e "$arg1" ]]; then
            echo "Error: File '$arg1' already exists. Overwriting is not allowed."
            log_action "FAILED create '$arg1' - file already exists"
            exit 1
        fi

        touch "$arg1"
        echo "File '$arg1' created successfully."
        log_action "CREATED '$arg1'"
        ;;

    delete)
        if [[ -z "$arg1" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi

        if [[ ! -e "$arg1" ]]; then
            echo "Error: File '$arg1' does not exist."
            log_action "FAILED delete '$arg1' - file not found"
            exit 1
        fi

        rm "$arg1"
        echo "File '$arg1' deleted successfully."
        log_action "DELETED '$arg1'"
        ;;

    list)
        echo "Files in current directory:"
        ls -lh
        log_action "LISTED files in $(pwd)"
        ;;

    rename)
        if [[ -z "$arg1" || -z "$arg2" ]]; then
            echo "Error: Please provide the current filename and new filename."
            exit 1
        fi

        if [[ ! -e "$arg1" ]]; then
            echo "Error: File '$arg1' does not exist."
            log_action "FAILED rename '$arg1' to '$arg2' - source file not found"
            exit 1
        fi

        if [[ -e "$arg2" ]]; then
            echo "Error: Target file '$arg2' already exists. Overwriting is not allowed."
            log_action "FAILED rename '$arg1' to '$arg2' - target exists"
            exit 1
        fi

        mv "$arg1" "$arg2"
        echo "File renamed from '$arg1' to '$arg2' successfully."
        log_action "RENAMED '$arg1' to '$arg2'"
        ;;

    *)
        echo "Usage:"
        echo "./file_manager.sh create <filename>"
        echo "./file_manager.sh delete <filename>"
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename <oldname> <newname>"
        exit 1
        ;;
esac
