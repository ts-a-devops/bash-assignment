#!/bin/bash

LOG_DIR="../logs"
BACKUP_DIR="../backups"

mkdir -p "$LOG_DIR" "$BACKUP_DIR"

LOG_FILE="$LOG_DIR/backup.log"

input_dir=$1

if [[ -z "$input_dir" ]]; then
	echo "Usage: $0 <directory>"
	exit 1
fi

# Check directory
if [[ ! -d "$input_dir" ]]; then
	echo "Error: Directory does not exist."
	exit 1
fi

# Adding Timestamp
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$input_dir"

echo "Backup created: $backup_file"
echo "$(date): Backup created for $input-dir" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t "$BACKUP_DIR" | tail -n +6 | while read file; do
	rm "$BACKUP_DIR/$file"
	echo "$(date): Deleted old backup $file" >> "$LOG_FILE"
done

