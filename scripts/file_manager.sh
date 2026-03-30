#!/bin/bash
#this is a script for file mananger
#./file_manager.sh create notes.txt
#./file_manager.sh list
#./file_manager.sh rename notes.txt readme.md
#./file_manager.sh delete readme.md


LOG_FILE="../logs/file_manager.log"

# Function to log actions
log_action() {
:    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage:"
    echo "  $0 create <filename>     - Create a new empty file (prevents overwrite)"
    echo "  $0 delete <filename>     - Delete a file"
    echo "  $0 list [directory]      - List files (default: current directory)"
    echo "  $0 rename <oldname> <newname>  - Rename a file"
    exit 1
fi

COMMAND=$1
shift   # Remove the first argument (the command)

case $COMMAND in

    create)
        if [ $# -ne 1 ]; then   #-ne = "not equal to"
            echo "Usage: $0 create <filename>"  #- $0 = Special variable that contains the name of the script itself.
            exit 1   #Stops the script immediately.The number 1 means "ended with an error"
	fi
        
        FILE="$1"
        
        if [ -e "$FILE" ]; then #-e means "does this exist?" (It checks if a file or folder with that name already exists).
            echo "Error: File '$FILE' already exists. Overwriting is not allowed."
            log_action "CREATE FAILED: File '$FILE' already exists"
            exit 1
        fi
        
        if touch "$FILE"; then
            echo "File '$FILE' created successfully."
            log_action "CREATE: File '$FILE' created"
        else
            echo "Error: Failed to create file '$FILE'."
            log_action "CREATE FAILED: Failed to create '$FILE'"
            exit 1
        fi
        ;;

    delete)
        if [ $# -ne 1 ]; then
            echo "Usage: $0 delete <filename>"
            exit 1
        fi
        
        FILE="$1"
        
        if [ ! -e "$FILE" ]; then
            echo "Error: File '$FILE' does not exist."
            log_action "DELETE FAILED: File '$FILE' does not exist"
            exit 1
        fi
        
        if rm "$FILE"; then
            echo "File '$FILE' deleted successfully."
            log_action "DELETE: File '$FILE' deleted"
        else
            echo "Error: Failed to delete file '$FILE'."
            log_action "DELETE FAILED: Failed to delete '$FILE'"
            exit 1
        fi
        ;;



    list)
        DIR="${1:-.}"  # Default to current directory if no argument
        
        if [ ! -d "$DIR" ]; then
            echo "Error: Directory '$DIR' does not exist."
            log_action "LIST FAILED: Directory '$DIR' does not exist"
            exit 1
        fi
        
        echo "Contents of directory: $DIR"
        ls -la "$DIR"
        log_action "LIST: Listed contents of directory '$DIR'"
        ;;

    rename)
        if [ $# -ne 2 ]; then
            echo "Usage: $0 rename <oldname> <newname>"
            exit 1
        fi
        
        OLD="$1"
        NEW="$2"
        
        if [ ! -e "$OLD" ]; then
            echo "Error: File or directory '$OLD' does not exist."
            log_action "RENAME FAILED: '$OLD' does not exist"
            exit 1
        fi
        
        if [ -e "$NEW" ]; then
            echo "Error: '$NEW' already exists. Cannot overwrite."
            log_action "RENAME FAILED: Target '$NEW' already exists"
            exit 1
        fi
        
        if mv "$OLD" "$NEW"; then
            echo "Successfully renamed '$OLD' to '$NEW'."
            log_action "RENAME: '$OLD' -> '$NEW'"
        else
            echo "Error: Failed to rename '$OLD' to '$NEW'."
            log_action "RENAME FAILED: Failed to rename '$OLD' to '$NEW'"
            exit 1
        fi
        ;;

    *)
        echo "Error: Unknown command '$COMMAND'"
        echo "Supported commands: create, delete, list, rename"
        exit 1
        ;;
esac


































