
#!/bin/bash

SOURCE_DIR=$1
BACKUP_DIR="../backup"
LOG_FILE="../logs/backup.log"

# Validating Input
if [[ -z "$SOURCE_DIR" ]]; then
    echo "NO DIRECTORY PROVIDED" | tee -a "$LOG_FILE"
    echo "Usage: ./backup.sh <directory>" | tee -a "$LOG_FILE"
    exit 1
fi

# To check if directory exits
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Directory '$SOURCE_DIR' does not exits" | tee -a "$LOG_FILE"
    exit 1
fi

# Create Timestamp
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
# Backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[ $? -eq 0 ]]; then
    echo "Backup created successfully -> $BACKUP_FILE" | tee -a "$LOG_FILE"
else
    echo "Backup Failed" | tee -a "$LOG_FILE"
    exit 1
fi

# Keep last 5 backups
cd "$BACKUP_DIR" || exit

BACKUP_COUNT=$(ls -l backup_*.tar.gz 2>/dev/null | wc -l)

if [[ "$BACKUP_COUNT" -gt 5 ]]; then
    ls -lt backup_*.tar.gz | tail -n +6 | while read old_file
    do
        rm -f "$old_file"
	echo "Deleted old backup -> $old_file" | tee -a "$LOG_FILE"
    done
fi
