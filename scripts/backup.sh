
#!/bin/bash
# This script creates a compressed backup of a directory
# It stores the backup inside the backups/ folder
# It also keeps only the latest 5 backups

# Create logs directory if it doesn't exist
mkdir -p logs

# Create backups directory if it doesn't exist
mkdir -p backups

# Define the log file location
LOG_FILE="logs/backup.log"

# Store current timestamp (used for unique backup file name)
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# The first argument passed to the script is the directory to back up
TARGET_DIR=$1


# Function to write messages into the log file
log_action() {
  # $1 represents the message passed into this function
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}


# Check if user provided a directory argument
if [ -z "$TARGET_DIR" ]; then
  echo "Error: No directory provided."
  echo "Usage: ./backup.sh <directory_path>"
  log_action "ERROR: No directory provided. Backup aborted."
  exit 1
fi


# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' does not exist."
  log_action "ERROR: Directory '$TARGET_DIR' does not exist. Backup aborted."
  exit 1
fi


# Get the base name of the directory (example: /home/user/docs -> docs)
DIR_NAME=$(basename "$TARGET_DIR")

# Define backup file name
BACKUP_FILE="backup_${DIR_NAME}_${TIMESTAMP}.tar.gz"

# Define the full backup file path inside backups/
BACKUP_PATH="backups/$BACKUP_FILE"


# Print message to terminal
echo "Creating backup for directory: $TARGET_DIR ..."

# Log backup start
log_action "INFO: Starting backup for directory '$TARGET_DIR'."

# Create compressed backup using tar
# -c = create archive
# -z = compress with gzip
# -f = specify output file name
tar -czf "$BACKUP_PATH" "$TARGET_DIR"

# Check if tar command was successful
if [ $? -eq 0 ]; then
  echo "Backup created successfully: $BACKUP_PATH"
  log_action "SUCCESS: Backup created successfully at '$BACKUP_PATH'."
else
  echo "Error: Backup failed."
  log_action "ERROR: Backup failed while creating '$BACKUP_PATH'."
  exit 1
fi


# -----------------------------
# KEEP ONLY LAST 5 BACKUPS
# -----------------------------

# Print cleanup message
echo "Cleaning old backups (keeping latest 5)..."

# Log cleanup start
log_action "INFO: Cleaning old backups (keeping only latest 5)."

# List backup files sorted by newest first
# tail -n +6 selects everything from the 6th file onward
# xargs rm -f deletes those older backups
ls -1t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs rm -f

# Log cleanup completion
log_action "SUCCESS: Old backups cleanup completed."


# Final message
echo "Backup process completed."

# Log completion
log_action "INFO: Backup process completed successfully."

exit 0
