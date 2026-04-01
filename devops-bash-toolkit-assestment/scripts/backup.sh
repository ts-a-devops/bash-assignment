#!/bin/bash
set -euo pipefail
DIR=${1:-}
DEST="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ ! -d "$DIR" ]; then echo "Directory $DIR not found!"; exit 1; fi

tar -czf "$DEST/backup_$TIMESTAMP.tar.gz" "$DIR"
echo "Backup saved to $DEST/backup_$TIMESTAMP.tar.gz" >> logs/backup.log

# Keep only last 5
ls -t $DEST/backup_*.tar.gz | tail -n +6 | xargs -r rm
