
LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/file_manager.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

usage() {
    echo "Usage:"
    echo "  $0 create <filename>"
    echo "  $0 delete <filename>"
    echo "  $0 list   [directory]"
    echo "  $0 rename <old_name> <new_name>"
    exit 1
}

CMD="$1"

case "$CMD" in

    create)
        [[ -z "$2" ]] && { echo "Error: Please provide a filename."; usage; }
        FILE="$2"
        if [[ -e "$FILE" ]]; then
            log "SKIPPED create '$FILE' — file already exists."
            echo "Error: '$FILE' already exists. Will not overwrite."
            exit 1
        fi
        touch "$FILE"
        log "CREATED '$FILE'"
        echo "✅ File '$FILE' created."
        ;;

    delete)
        [[ -z "$2" ]] && { echo "Error: Please provide a filename."; usage; }
        FILE="$2"
        if [[ ! -e "$FILE" ]]; then
            log "FAILED delete '$FILE' — file not found."
            echo "Error: '$FILE' does not exist."
            exit 1
        fi
        rm "$FILE"
        log "DELETED '$FILE'"
        echo "🗑️  File '$FILE' deleted."
        ;;

    list)
        DIR="${2:-.}"
        if [[ ! -d "$DIR" ]]; then
            log "FAILED list '$DIR' — directory not found."
            echo "Error: Directory '$DIR' does not exist."
            exit 1
        fi
        echo "📂 Contents of '$DIR':"
        ls -lh "$DIR"
        log "LISTED directory '$DIR'"
        ;;

    rename)
        [[ -z "$2" || -z "$3" ]] && { echo "Error: Provide old and new names."; usage; }
        OLD="$2"; NEW="$3"
        if [[ ! -e "$OLD" ]]; then
            log "FAILED rename '$OLD' — source not found."
            echo "Error: '$OLD' does not exist."
            exit 1
        fi
        if [[ -e "$NEW" ]]; then
            log "SKIPPED rename '$OLD' → '$NEW' — destination already exists."
            echo "Error: '$NEW' already exists. Will not overwrite."
            exit 1
        fi
        mv "$OLD" "$NEW"
        log "RENAMED '$OLD' → '$NEW'"
        echo "✏️  Renamed '$OLD' to '$NEW'."
        ;;

    *)
        echo "Error: Unknown command '$CMD'."
        usage
        ;;
esac

