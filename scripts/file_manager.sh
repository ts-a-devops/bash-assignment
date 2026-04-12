#!/bin/bash


LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"


mkdir -p "$LOG_DIR"

log_action() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Usage
usage() {
    echo "Usage: $0 <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  create <filename>          Create a new file"
    echo "  delete <filename>          Delete a file"
    echo "  list                       List files in current directory"
    echo "  rename <oldname> <newname> Rename a file"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

COMMAND=$1
shift

case $COMMAND in

    create)
        if [ $# -ne 1 ]; then
            echo "Error: create requires one filename."
            usage
        fi
        TARGET=$1

        if [ -e "$TARGET" ]; then
            echo "Error: File '$TARGET' already exists. Overwriting not allowed."
            log_action "CREATE FAILED: '$TARGET' already exists"
            exit 1
        fi

        touch "$TARGET"
        if [ $? -eq 0 ]; then
            echo "File '$TARGET' created successfully."
            log_action "CREATE: '$TARGET' created"
        else
            echo "Error: Failed to create file '$TARGET'."
            log_action "CREATE FAILED: '$TARGET'"
        fi
        ;;

    delete)
        if [ $# -ne 1 ]; then
            echo "Error: delete requires one filename."
            usage
        fi
        TARGET=$1

        if [ ! -f "$TARGET" ]; then
            echo "Error: File '$TARGET' not found."
            log_action "DELETE FAILED: '$TARGET' not found"
            exit 1
        fi

        rm "$TARGET"
        if [ $? -eq 0 ]; then
            echo "File '$TARGET' deleted successfully."
            log_action "DELETE: '$TARGET' deleted"
        else
            echo "Error: Failed to delete '$TARGET'."
            log_action "DELETE FAILED: '$TARGET'"
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls -la
        log_action "LIST: Directory listing performed"
        ;;

    rename)
        if [ $# -ne 2 ]; then
            echo "Error: rename requires oldname and newname."
            usage
        fi
        TARGET=$1
        NEWNAME=$2

        if [ ! -f "$TARGET" ]; then
            echo "Error: File '$TARGET' not found."
            log_action "RENAME FAILED: '$TARGET' not found"
            exit 1
        fi

        if [ -e "$NEWNAME" ]; then
            echo "Error: '$NEWNAME' already exists. Cannot overwrite."
            log_action "RENAME FAILED: '$NEWNAME' already exists"
            exit 1
        fi

        mv "$TARGET" "$NEWNAME"
        if [ $? -eq 0 ]; then
            echo "Successfully renamed '$TARGET' to '$NEWNAME'."
            log_action "RENAME: '$TARGET' → '$NEWNAME'"
        else
            echo "Error: Failed to rename '$TARGET' to '$NEWNAME'."
            log_action "RENAME FAILED: '$TARGET' → '$NEWNAME'"
        fi
        ;;

    *)
        echo "Error: Unknown command '$COMMAND'"
        usage
        ;;
esac

