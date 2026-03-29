#!/bin/bash
TARGET=$1
DEST="../backups"

if [[ ! -d "$TARGET" ]]; then
    echo "Source directory does not exist."
    exit 1
fi

# Create timestamped backup
tar -czf "$DEST/backup_$(date +%Y%m%d_%H%M%S).tar.gz" "$TARGET"

# Keep only 5: List by time, skip first 5, delete the rest
ls -t "$DEST"/backup_* | tail -n +6 | xargs rm -f 2>/dev/null
