#!/bin/bash


set -euo pipefail

BACKUP_DIR="backups"                  
LOG_FILE="backup.log"                 
RETENTION=5                           


if [ $# -eq 0 ]; then
    echo "Error: No directory provided." | tee -a "$LOG_FILE"
    echo "Usage: $0 /path/to/directory" | tee -a "$LOG_FILE"
    exit 1
fi

SOURCE_DIR="$1"


if [ ! -d "$SOURCE_DIR" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Directory '$SOURCE_DIR' does not exist or is not a directory." | tee -a "$LOG_FILE"
    exit 1
fi


mkdir -p "$BACKUP_DIR"


TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="\( {BACKUP_DIR}/backup_ \){TIMESTAMP}.tar.gz"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: Starting backup of '$SOURCE_DIR' ..." | tee -a "$LOG_FILE"


if tar -czf "\( BACKUP_FILE" -C " \)(dirname "\( SOURCE_DIR")" " \)(basename "$SOURCE_DIR")" 2>> "$LOG_FILE"; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: Backup created → $BACKUP_FILE" | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Backup creation failed!" | tee -a "$LOG_FILE"
    exit 1
fi


echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: Rotating backups (keeping last $RETENTION) ..." | tee -a "$LOG_FILE"
cd "$BACKUP_DIR" || exit 1
ls -t backup_*.tar.gz 2>/dev/null | tail -n +$((RETENTION + 1)) | xargs -I {} rm -- "{}" 2>> "../$LOG_FILE" || true
cd - > /dev/null

echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: Backup process completed successfully." | tee -a "$LOG_FILE"
echo "--------------------------------------------------" | tee -a "$LOG_FILE"

