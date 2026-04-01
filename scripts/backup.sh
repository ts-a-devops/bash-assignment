#!/bin/bash
set -euo pipefail
DIR="${1:-}"
if [ -z "$DIR" ]; then 
echo "Usage: $0 <directory>"
exit 1
fi
if [ ! -d "$DIR" ]; then
echo "Error: Directory does not exixt"
exit 1
fi
mkdir -p backups
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backups/backup_${TIMESTAMP}.tar.gz"
tar -czf "$BACKUP_FILE" "$DIR"
cd backups
ls -1t backup_*.tar.gz | tail -n +6 | xargs rm -f
cd ..
mkdir -p logs
echo "$(date '+%Y-%d %H:%M:%S') - Backup created: $BACKUP_FILE" >> logs/backup.log
echo "Backup sucessful: $BACKUP_FILE"
