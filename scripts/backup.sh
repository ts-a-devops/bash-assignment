#!/bin/bash

# 1. SETUP: Where are things going?
SOURCE=$1
DEST="../backups"
LOG="../logs/backup.log"
TIME=$(date +"%Y%m%d_%H%M%S")

# 2. SAFETY: Create folders if they don't exist
mkdir -p "$DEST" "$(dirname "$LOG")"

# 3. CHECK: Did the user provide a valid folder to backup?
if [[ ! -d "$SOURCE" ]]; then
    echo "Usage: $0 [folder_to_backup]"
    exit 1
fi

# 4. ACTION: Compress the folder
# We save the file name in a variable to keep the command clean
FILENAME="$DEST/backup_$TIME.tar.gz"

tar -czf "$FILENAME" "$SOURCE"
echo "[$TIME] Saved: $FILENAME" >> "$LOG"

# 5. CLEANUP: Delete everything except the 5 newest backups
# 'ls -t' puts newest first, 'tail' picks everything after the 5th
ls -t "$DEST"/backup_*.tar.gz | tail -n +6 | xargs rm -f

echo "[$TIME] Cleanup complete." >> "$LOG"