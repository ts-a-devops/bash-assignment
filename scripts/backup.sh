#!/usr/bin/bash
set -o pipefail
shopt -s nullglob #This helps me tell bash that when nothing matches my wilcard text, give me nothing.

mkdir -p backups logs

directory="${1/#\~/$HOME}"

	#Accept a directory as input and validate that the directory exists
{
echo "$(date '+%B %d %T')"
if [[ -z "$directory" ]]; then
	echo "ERROR: Please provide a directory to back up."
	echo "Usage: $0 <directory>"
    exit 1
fi

if [[ ! -d "$directory" ]]; then
	echo "ERROR: '$directory' is not a valid directory."
    exit 1
fi

	 # Get parent directory and actual folder name

parent_dir=$(dirname "$directory")
dir_name=$(basename "$directory")

	# Create backup filename with timestamp

timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="backups/${dir_name}_backup_${timestamp}.tar.gz"

	# Create compressed backup

if tar -czf "$backup_file" -C "$parent_dir" "$dir_name"; then
        echo "Backup created successfully: $backup_file"
    else
        echo "ERROR: Failed to create backup for '$directory'"
    exit 1
fi

	# Keep only the last 5 backups
backedup_files=(backups/backup_*.tar.gz)

if (( ${#backedup_files[@]} > 5 )); then
	old_backups=($(ls -1t backups/backup_*.tar.gz | tail -n +6))

for old_file in "${old_backups[@]}"; do
	if rm -f "$old_file"; then
                echo "Deleted old backup: $old_file"
        else
                echo "ERROR: Failed to delete old backup: $old_file"
        exit 1
        fi
done
fi
	echo "Backup process completed."
	echo
} | tee -a logs/backup.log
