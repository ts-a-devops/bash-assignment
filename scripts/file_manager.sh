#!/bin/bash

# Expected to log all actions
LOG_FILE="logs/file_manager.log"

#create the directory if it does not exist
mkdir -p logs

INSTRUCTIONS="To use this script:
Commands: create, delete, list, rename
Usage examples:
  ./file_manager.sh create file.txt
  ./file_manager.sh delete file.txt
  ./file_manager.sh list
  ./file_manager.sh rename filename ...... and system ask for the renam value"



# Check if at least the first argument (command) is provided

if [[ -z "$1" ]]; then #checks if the first argument is empty =true then give the instructions
    echo "Error: No command provided."
    echo "Please provide a command (create, delete, list, rename) and optionally a file or directory."
    echo "$INSTRUCTIONS"

    #indicate to the user something went wrong
    exit 1
fi



# Check for list comand first because list command; can list current (empty string) and a specified directory (argument 2)

if [[ "$1" == "list" ]]; then
    if [[ -n "$2" ]]; then
        if [[ -d "$2" ]]; then
            ls "$2"
            OUTPUT="Listed directory $2"
        else
            echo "Directory $2 does not exist"
            OUTPUT="Failed to list directory $2"
        fi
    else
        ls
        OUTPUT="Listed current directory"
    fi
    echo "$OUTPUT" | tee -a "$LOG_FILE"

    #terminate the process (script) if this is true
    exit 0
fi

# Check if $2 exists as a file
if [[ -f "$2" ]]; then
    case "$1" in 
        delete)
            rm -rf "$2"
            OUTPUT="$2 file has been deleted"
            echo "$2 has been deleted"
        ;; 

        rename)
            read -p "Rename file: " NEW_FILE
            mv "$2" "$NEW_FILE"
            OUTPUT="File $2 renamed to $NEW_FILE"
            echo "File has been renamed"
        ;;

        *)
            echo "You can either delete or rename this file"
        ;;
    esac

# Check if $2 does not exist
elif [[ ! -e "$2" ]]; then
    case "$1" in
        create)
            touch "$2"
            OUTPUT="$2 has been created"
            echo "$2 has been created"
        ;;
        *)
            echo "$2 does not exist. Cannot perform $1"
            OUTPUT="Failed $1: $2 does not exist"
        ;;
    esac

# Check if $2 exists as a directory
elif [[ -d "$2" ]]; then
    case "$1" in 
        delete)
            rm -rf "$2"
            OUTPUT="$2 directory has been deleted"
            echo "$2 deleted directory!"
        ;;

        rename)
            read -p "New directory name: " NEW_NAME
            mv "$2" "$NEW_NAME"
            OUTPUT="Directory $2 renamed to $NEW_NAME"
            echo "Directory has been renamed"
        ;;

        list)
            ls "$2"
            OUTPUT="Listing directory $2"
            echo "Listing the directory"
        ;;

        *)
            echo "Enter a valid argument e.g list, rename, delete"
            OUTPUT="Invalid command $1 for directory $2"
        ;;
    esac

# If $2 doesn’t exist at all
else
    echo "The directory or file does not exist"
    mkdir -p "$2"
    OUTPUT="Created new directory $2"
    echo "Directory has been created"
fi

# Log the action
echo "$OUTPUT" | tee -a "$LOG_FILE"