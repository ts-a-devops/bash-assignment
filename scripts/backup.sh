
#!/bin/bash

BACKUP_DIR="../backups"
LOG_FILE="../logs/backup.log"

mkdir -p $BACKUP_DIR ../logs

DIR=$1

if [ -z "$DIR" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Directory does not exist."
    exit 1
fi

timestamp=$(date +%Y%m%d%H%M%S)
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$DIR"

echo "Backup created: $backup_file" >> $LOG_FILE

# Keep only last 5 backups
ls -t $BACKUP_DIR | tail -n +6 | while read file
do
    rm "$BACKUP_DIR/$file"
done
