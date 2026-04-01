#!/bin/bash
# file_manager.sh - File management utility

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/file_manager.log"

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

log_action() {
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

show_usage() {
    echo "Usage: ./file_manager.sh <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  create <filename>           - Create a new file"
    echo "  delete <filename>           - Delete a file"
    echo "  list [directory]            - List files in a directory (default: current)"
    echo "  rename <oldname> <newname>  - Rename a file"
    echo ""
    echo "Example:"
    echo "  ./file_manager.sh create myfile.txt"
}

COMMAND=$1

case "$COMMAND" in

    create)
        FILENAME=$2
        if [[ -z "$FILENAME" ]]; then
            echo "Error: Please provide a filename."
            echo "Usage: ./file_manager.sh create <filename>"
            exit 1
        fi
        if [[ -e "$FILENAME" ]]; then
            echo "Error: File '$FILENAME' already exists. Will not overwrite."
            log_action "FAILED create '$FILENAME' — file already exists."
            exit 1
        fi
        touch "$FILENAME"
        echo "✅ File '$FILENAME' created successfully."
        log_action "CREATED '$FILENAME'"
        ;;

    delete)
        FILENAME=$2
        if [[ -z "$FILENAME" ]]; then
            echo "Error: Please provide a filename."
            echo "Usage: ./file_manager.sh delete <filename>"
            exit 1
        fi
        if [[ ! -e "$FILENAME" ]]; then
            echo "Error: File '$FILENAME' does not exist."
            log_action "FAILED delete '$FILENAME' — file not found."
            exit 1
        fi
        rm "$FILENAME"
        echo "✅ File '$FILENAME' deleted successfully."
        log_action "DELETED '$FILENAME'"
        ;;

    list)
        DIR=${2:-.}
        if [[ ! -d "$DIR" ]]; then
            echo "Error: Directory '$DIR' does not exist."
            log_action "FAILED list '$DIR' — directory not found."
            exit 1
        fi
        echo "📂 Contents of '$DIR':"
        ls -lh "$DIR"
        log_action "LISTED contents of '$DIR'"
        ;;

    rename)
        OLDNAME=$2
        NEWNAME=$3
        if [[ -z "$OLDNAME" || -z "$NEWNAME" ]]; then
            echo "Error: Please provide both old and new filenames."
            echo "Usage: ./file_manager.sh rename <oldname> <newname>"
            exit 1
        fi
        if [[ ! -e "$OLDNAME" ]]; then
            echo "Error: File '$OLDNAME' does not exist."
            log_action "FAILED rename '$OLDNAME' — file not found."
            exit 1
        fi
        if [[ -e "$NEWNAME" ]]; then
            echo "Error: A file named '$NEWNAME' already exists. Will not overwrite."
            log_action "FAILED rename '$OLDNAME' to '$NEWNAME' — target already exists."
            exit 1
        fi
        mv "$OLDNAME" "$NEWNAME"
        echo "✅ Renamed '$OLDNAME' to '$NEWNAME' successfully."
        log_action "RENAMED '$OLDNAME' to '$NEWNAME'"
        ;;

    *)
        echo "Error: Unknown command '$COMMAND'."
        echo ""
        show_usage
        exit 1
        ;;
esac
