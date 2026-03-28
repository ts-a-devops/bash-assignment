
#!/bin/bash

# Create necessary directories
mkdir -p backups logs

# Log file
log_file="logs/backup.log"

# Function to log actions
log_action() {
    echo "$(date): $1" >> "$log_file"
}

# Check if directory argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

dir_to_backup="$1"

# Validate directory exists
if [ ! -d "$dir_to_backup" ]; then
    echo "Error: Directory $dir_to_backup does not exist."
    log_action "BACKUP FAILED: $dir_to_backup does not exist."
    exit 1
fi

# Create timestamped backup
timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="backups/backup_${timestamp}.tar.gz"

tar -czf "$backup_file" -C "$dir_to_backup" .
if [ $? -eq 0 ]; then
    echo "Backup created: $backup_file"
    log_action "BACKUP SUCCESS: $backup_file"
else
    echo "Backup failed!"
    log_action "BACKUP FAILED: $backup_file"
    exit 1
fi

# Keep only last 5 backups
backup_count=$(ls backups/backup_*.tar.gz 2>/dev/null | wc -l)
if [ "$backup_count" -gt 5 ]; then
    # Delete oldest backups
    backups_to_delete=$(ls -t backups/backup_*.tar.gz | tail -n +6)
    for old_backup in $backups_to_delete; do
        rm "$old_backup"
        log_action "OLD BACKUP DELETED: $old_backup"
    done
fi
