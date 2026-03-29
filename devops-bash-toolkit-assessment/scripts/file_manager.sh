
#!/bin/bash

#1. setup logs
mkdir -p logs
LOG_FILE="logs/file_manager.log"

# 2. Get the command and the filename from the user's input
ACTION=$1
FILENAME=$2
NEW_NAME=$3  # Only used for the 'rename' command

# Function to log actions with a timestamp
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 3. Handle the commands
case "$ACTION" in
    create)
        if [ -e "$FILENAME" ]; then
            echo "Error: File '$FILENAME' already exists. Overwrite prevented."
        else
            touch "$FILENAME"
            echo "File '$FILENAME' created successfully."
            log_action "CREATED: $FILENAME"
        fi
        ;;

    delete)
        if [ -f "$FILENAME" ]; then
            rm "$FILENAME"
            echo "File '$FILENAME' deleted."
            log_action "DELETED: $FILENAME"
        else
            echo "Error: File '$FILENAME' not found."
        fi
        ;;

    list)
        echo "Listing files in current directory:"
        ls -F
        log_action "LISTED files"
        ;;

    rename)
        if [ -z "$NEW_NAME" ]; then
            echo "Usage: ./file_manager.sh rename [old_name] [new_name]"
        elif [ ! -f "$FILENAME" ]; then
            echo "Error: Source file '$FILENAME' does not exist."
        elif [ -e "$NEW_NAME" ]; then
            echo "Error: A file named '$NEW_NAME' already exists."
        else
            mv "$FILENAME" "$NEW_NAME"
            echo "Renamed '$FILENAME' to '$NEW_NAME'."
            log_action "RENAMED: $FILENAME to $NEW_NAME"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename} [filename] [new_filename]"
        ;;
esac
