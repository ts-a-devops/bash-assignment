#!/bin/bash
# file_manager.sh - create, delete, list, rename files with logging

LOGFILE="logs/file_manager.log"
mkdir -p logs

# Function to log actions
log_action() {
    echo "$(date '+%F %T') - $1" >> $LOGFILE
}

# Check usage
if [ $# -lt 2 ]; then
    echo "Usage: $0 {create|delete|list|rename} filename [newname]"
    exit 1
fi

COMMAND=$1
FILE=$2
NEWNAME=$3

case $COMMAND in
    create)
        if [ -e "$FILE" ]; then
            echo "Error: $FILE already exists"
            log_action "CREATE FAILED - $FILE exists"
        else
            touch "$FILE"
            echo "$FILE created successfully"
            log_action "CREATED - $FILE"
        fi
        ;;
    delete)
        if [ -e "$FILE" ]; then
            rm "$FILE"
            echo "$FILE deleted successfully"
            log_action "DELETED - $FILE"
        else
            echo "Error: $FILE does not exist"
            log_action "DELETE FAILED - $FILE missing"
        fi
        ;;
    list)
        echo "Listing files:"
        ls -l
        log_action "LISTED files"
        ;;
    rename)
        if [ -z "$NEWNAME" ]; then
            echo "Error: new name required for rename"
            exit 1
        fi
        if [ -e "$FILE" ]; then
            mv "$FILE" "$NEWNAME"
            echo "$FILE renamed to $NEWNAME"
            log_action "RENAMED - $FILE to $NEWNAME"
        else
            echo "Error: $FILE does not exist"
            log_action "RENAME FAILED - $FILE missing"
        fi
        ;;
    *)
        echo "Invalid command. Use create, delete, list, or rename"
        exit 1
        ;;
esac
