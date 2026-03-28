#!/bin/bash

log_file="logs/file_manager.log"
mkdir -p logs

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2 - $3" >> "$log_file"; }

case "$1" in
    create)
        [ -e "$2" ] && { echo "ERROR: $2 exists"; log "CREATE" "$2" "FAILED"; exit 1; }
        [[ "$2" == */ ]] && mkdir -p "$2" || touch "$2"
        echo "✓ Created: $2"; log "CREATE" "$2" "SUCCESS"
        ;;
    delete)
        [ ! -e "$2" ] && { echo "ERROR: $2 not found"; log "DELETE" "$2" "FAILED"; exit 1; }
        [ -d "$2" ] && rmdir "$2" 2>/dev/null || rm "$2"
        echo "✓ Deleted: $2"; log "DELETE" "$2" "SUCCESS"
        ;;
    list)
        ls -la "${2:-.}"
        log "LIST" "${2:-.}" "SUCCESS"
        ;;
    rename)
        [ ! -e "$2" ] && { echo "ERROR: $2 not found"; exit 1; }
        [ -e "$3" ] && { echo "ERROR: $3 exists"; exit 1; }
        mv "$2" "$3"
        echo "✓ Renamed: $2 → $3"; log "RENAME" "$2" "SUCCESS → $3"
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename} [args]"
        ;;
esac