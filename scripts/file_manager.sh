#!/bin/bash

LOG_FILE="logs/file_manager.log"


ACTION=$1
TARGET=$2
NEW_NAME=$3

case $ACTION in
    
    # ==== Creating the file =====	
    create)
        if [ -z "$TARGET" ]; then
            echo "Error: No filename provided."
            exit 1
        fi

        if [ -e "$TARGET" ]; then
            echo "Error: File already exists. Cannot overwrite."
            echo "$(date) - CREATE FAILED: $TARGET already exists" >> $LOG_FILE
            exit 1
        fi

        touch "$TARGET"
        echo "File '$TARGET' created."
        echo "$(date) - CREATED: $TARGET" >> $LOG_FILE
        ;;


    # ==== Deletes the file ====
    delete)
        if [ -z "$TARGET" ]; then
            echo "Error: No filename provided."
            exit 1
        fi

        if [ ! -e "$TARGET" ]; then
            echo "Error: File does not exist."
            echo "$(date) - DELETE FAILED: $TARGET not found" >> $LOG_FILE
            exit 1
        fi

        rm "$TARGET"
        echo "File '$TARGET' deleted."
        echo "$(date) - DELETED: $TARGET" >> $LOG_FILE
        ;;

    # ==== Lists files in current directory ====
    list)
        echo "Files in current directory:"
        ls
        echo "$(date) - LISTED FILES" >> $LOG_FILE
        ;;

  	
    # ==== Rename the file ====
    rename)
        if [ -z "$TARGET" ] || [ -z "$NEW_NAME" ]; then
            echo "Error: Provide old and new filename."
            exit 1
        fi

        if [ ! -e "$TARGET" ]; then
            echo "Error: File does not exist."
            echo "$(date) - RENAME FAILED: $TARGET not found" >> $LOG_FILE
            exit 1
        fi

        if [ -e "$NEW_NAME" ]; then
            echo "Error: New filename already exists."
            echo "$(date) - RENAME FAILED: $NEW_NAME already exists" >> $LOG_FILE
            exit 1
        fi

        mv "$TARGET" "$NEW_NAME"
        echo "File renamed from '$TARGET' to '$NEW_NAME'."
        echo "$(date) - RENAMED: $TARGET to $NEW_NAME" >> $LOG_FILE
	;;

    *)
        echo "Usage:"
        echo "./file_manager.sh create filename"
        echo "./file_manager.sh delete filename"
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename oldname newname"
        ;;
esac
