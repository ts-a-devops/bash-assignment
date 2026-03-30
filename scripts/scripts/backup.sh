#!/bin/bash
# backup.sh - Create compressed backup and retain only last 5

mkdir -p backups logs

DIR=$1
if [ ! -d "$DIR" ]; then
	echo "Directory $DIR does not exist."
	exit 1
fi 
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$DIR"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup created: $BACKUP_FILE" >> logs/backup.log
echo "Backup completed: $BACKUP_FILE"

# Keep only last 5 backups
BACKUPS_TO_DELETE=$(ls -1t backups/backup_*.tar.gz | tail -n +6)
for old in $BACKUPS_TO_DELETE; do
	rm "$old"
	echo "Deleted old backup:$old" >> logs/backup.log
done
