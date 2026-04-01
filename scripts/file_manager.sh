#!/bin/bash
# This script is a simple file manager tool
# It supports: create, delete, list, rename

# Create logs directory if it does not exist
mkdir -p logs

# Define the log file where actions will be saved
LOG_FILE="logs/file_manager.log"

# Store the current date/time in a variable for logging
NOW=$(date +"%Y-%m-%d %H:%M:%S")

# The first argument passed to the script is the command (create/delete/list/rename)
COMMAND=$1

# The second argument is usually the file name
FILE_NAME=$2

# The third argument is used for rename (new name)
NEW_NAME=$3


# Function to log actions into the log file
log_action() {
  # $1 means the first argument passed into the function
  echo "[$NOW] $1" >> "$LOG_FILE"
}


# Check if the user provided a command
# If COMMAND is empty, show usage instructions
if [ -z "$COMMAND" ]; then
  echo "Error: No command provided."
  echo "Usage:"
  echo "./file_manager.sh create <filename>"
  echo "./file_manager.sh delete <filename>"
  echo "./file_manager.sh list"
  echo "./file_manager.sh rename <oldname> <newname>"

  # Log the error
  log_action "ERROR: No command provided."

  # Exit with error status
  exit 1
fi


# ----------------------------
# CREATE FILE COMMAND
# ----------------------------
if [ "$COMMAND" == "create" ]; then

  # Check if filename is missing
  if [ -z "$FILE_NAME" ]; then
    echo "Error: No file name provided for create."
    log_action "ERROR: Create command failed (missing filename)."
    exit 1
  fi

  # Prevent overwriting: check if file already exists
  if [ -e "$FILE_NAME" ]; then
    echo "Error: File '$FILE_NAME' already exists. Cannot overwrite."
    log_action "ERROR: File '$FILE_NAME' already exists. Create aborted."
    exit 1
  fi

  # Create the file using touch
  touch "$FILE_NAME"

  # Confirm to the user
  echo "File '$FILE_NAME' created successfully."

  # Log success
  log_action "SUCCESS: Created file '$FILE_NAME'."

  exit 0
fi


# ----------------------------
# DELETE FILE COMMAND
# ----------------------------
if [ "$COMMAND" == "delete" ]; then

  # Check if filename is missing
  if [ -z "$FILE_NAME" ]; then
    echo "Error: No file name provided for delete."
    log_action "ERROR: Delete command failed (missing filename)."
    exit 1
  fi

  # Check if file exists before deleting
  if [ ! -e "$FILE_NAME" ]; then
    echo "Error: File '$FILE_NAME' does not exist."
    log_action "ERROR: File '$FILE_NAME' does not exist. Delete aborted."
    exit 1
  fi

  # Delete the file
  rm "$FILE_NAME"

  # Confirm to the user
  echo "File '$FILE_NAME' deleted successfully."

  # Log success
  log_action "SUCCESS: Deleted file '$FILE_NAME'."

  exit 0
fi


# ----------------------------
# LIST FILES COMMAND
# ----------------------------
if [ "$COMMAND" == "list" ]; then

  # List all files in the current directory
  echo "Listing files in current directory:"
  ls -lh

  # Log action
  log_action "INFO: Listed files in directory '$(pwd)'."

  exit 0
fi


# ----------------------------
# RENAME FILE COMMAND
# ----------------------------
if [ "$COMMAND" == "rename" ]; then

  # Check if old file name is missing
  if [ -z "$FILE_NAME" ]; then
    echo "Error: No old file name provided for rename."
    log_action "ERROR: Rename failed (missing old filename)."
    exit 1
  fi

  # Check if new name is missing
  if [ -z "$NEW_NAME" ]; then
    echo "Error: No new file name provided for rename."
    log_action "ERROR: Rename failed (missing new filename)."
    exit 1
  fi

  # Check if the old file exists
  if [ ! -e "$FILE_NAME" ]; then
    echo "Error: File '$FILE_NAME' does not exist."
    log_action "ERROR: Rename failed. File '$FILE_NAME' not found."
    exit 1
  fi

  # Prevent overwriting: check if new name already exists
  if [ -e "$NEW_NAME" ]; then
    echo "Error: File '$NEW_NAME' already exists. Rename aborted."
    log_action "ERROR: Rename aborted. '$NEW_NAME' already exists."
    exit 1
  fi

  # Rename the file using mv
  mv "$FILE_NAME" "$NEW_NAME"

  # Confirm to the user
  echo "File renamed from '$FILE_NAME' to '$NEW_NAME'."

  # Log success
  log_action "SUCCESS: Renamed '$FILE_NAME' to '$NEW_NAME'."

  exit 0
fi


# ----------------------------
# UNKNOWN COMMAND HANDLER
# ----------------------------

# If command is not recognized, show error
echo "Error: Unknown command '$COMMAND'."
echo "Available commands: create, delete, list, rename"

# Log unknown command
log_action "ERROR: Unknown command '$COMMAND'."

# Exit with error status
exit 1
