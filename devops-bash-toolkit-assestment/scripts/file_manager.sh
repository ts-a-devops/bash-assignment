#!/bin/bash
set -euo pipefail
LOG="logs/file_manager.log"
cmd=${1:-}
file=${2:-}

log_action() { echo "$(date): $1" >> "$LOG"; }

case "$cmd" in
    create)
        if [ -f "$file" ]; then echo "File exists!"; else touch "$file" && log_action "Created $file"; fi ;;
    delete)
        rm "$file" && log_action "Deleted $file" ;;
    list)
        ls -l ;;
    rename)
        mv "$file" "$3" && log_action "Renamed $file to $3" ;;
    *) echo "Usage: $0 {create|delete|list|rename}" ;;
esac
