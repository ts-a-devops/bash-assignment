#!/bin/bash
# --------------------------------------------------------------------------
# Script: file_manager.sh
# Description: Supports 'create', 'delete', 'list', 'rename' actions.
#              Logs all actions safely, preventing overwrite of files.
# --------------------------------------------------------------------------

LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/file_manager.log"

# Function to centrally log all events easily
log_action() {
    # $1 holds the message string
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# The first argument passed to the script is stored in $1. 
# We use this as our ACTION command (create, delete, list, rename).
ACTION=$1

# The 'case' statement routes execution based on the ACTION provided
case "$ACTION" in
    create)
        # The filename goes into $2.
        TARGET_FILE=$2
        # Check if the filename variable is empty
        if [ -z "$TARGET_FILE" ]; then
            echo "Error: You must specify a file name to create."
            log_action "[ERROR] 'create' attempted without filename."
            exit 1
        fi
        
        # Check if file already exists using '-f'
        if [ -f "$TARGET_FILE" ]; then
            echo "Error: File '$TARGET_FILE' already exists. Cannot overwrite!"
            log_action "[ERROR] Failed to create '$TARGET_FILE' - It already exists."
        else
            # the 'touch' command safely creates a file without any interior text
            touch "$TARGET_FILE"
            echo "Successfully created file: $TARGET_FILE"
            log_action "[INFO] Created file '$TARGET_FILE'."
        fi
        ;;

    delete)
        TARGET_FILE=$2
        if [ -z "$TARGET_FILE" ]; then
            echo "Error: You must specify a file name to delete."
            log_action "[ERROR] 'delete' attempted without filename."
            exit 1
        fi
        
        if [ -f "$TARGET_FILE" ]; then
            # The 'rm' command deletes files
            rm "$TARGET_FILE"
            echo "Successfully deleted file: $TARGET_FILE"
            log_action "[INFO] Deleted file '$TARGET_FILE'."
        else
            echo "Error: File '$TARGET_FILE' does not exist."
            log_action "[ERROR] Failed to delete '$TARGET_FILE' - It does not exist."
        fi
        ;;

    list)
        # We optionally take a directory path, defaulting to '.' (current directory)
        TARGET_DIR=${2:-.}
        
        # We ensure it's a real directory
        if [ -d "$TARGET_DIR" ]; then
            echo "Listing files in directory: $TARGET_DIR"
            ls -l "$TARGET_DIR"
            log_action "[INFO] Listed files in directory '$TARGET_DIR'."
        else
            echo "Error: Directory '$TARGET_DIR' does not exist."
            log_action "[ERROR] Failed to list '$TARGET_DIR' - Not a directory."
        fi
        ;;

    rename)
        SOURCE_FILE=$2
        NEW_FILE=$3
        
        if [ -z "$SOURCE_FILE" ] || [ -z "$NEW_FILE" ]; then
            echo "Error: You must specify both an original file and a new file name."
            log_action "[ERROR] 'rename' attempted with missing parameters."
            exit 1
        fi
        
        # Safety checks -> original must exist, new destination must NOT exist!
        if [ ! -f "$SOURCE_FILE" ]; then
             echo "Error: Source file '$SOURCE_FILE' does not exist."
             log_action "[ERROR] Failed to rename. Source '$SOURCE_FILE' missing."
        elif [ -f "$NEW_FILE" ]; then
             echo "Error: New file name '$NEW_FILE' already exists."
             log_action "[ERROR] Failed to rename. Destination '$NEW_FILE' already taken."
        else
             # the 'mv' command moves/renames files
             mv "$SOURCE_FILE" "$NEW_FILE"
             echo "Successfully renamed '$SOURCE_FILE' to '$NEW_FILE'."
             log_action "[INFO] Renamed '$SOURCE_FILE' to '$NEW_FILE'."
        fi
        ;;

    *)
        # If the user doesn't specify a valid action
        echo "Usage: ./file_manager.sh {create|delete|list|rename} [arguments...]"
        echo "Example: ./file_manager.sh create new_file.txt"
        log_action "[WARNING] Invalid file manager action invoked: '$ACTION'"
        ;;
esac
