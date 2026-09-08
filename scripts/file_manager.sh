#!/bin/bash

LOG_FILE="logs/file_manager.log"

ACTION=$1
FILE_1=$2
FILE_2=$3


case "$ACTION" in
    create)
	if [[ -e "$FILE_1" ]]; then
            echo "Error: '$FILE_1' already exists. Cannot overwrite."
            echo "$(date) - Failed to create '$FILE_1' (already exists)." >> "$LOG_FILE"
        else
            touch "$FILE_1"
            echo "Created '$FILE_1' successfully."
            echo "$(date) - Created file '$FILE_1'." >> "$LOG_FILE"
        fi
	;;
    delete)
	if [[ -e "$FILE_1" ]]; then
            rm "$FILE_1"
            echo "Deleted '$FILE_1' successfully."
            echo "$(date) - Deleted file '$FILE_1'." >> "$LOG_FILE"
        else
            echo "Error: '$FILE_1' does not exist."
            echo "$(date) - Failed to delete '$FILE_1' (not found)." >> "$LOG_FILE"
        fi
         ;;
    list)
	echo "Listing files in current directory:"
        ls -l
        echo "$(date) - Listed files in the directory." >> "$LOG_FILE"
        ;;
    rename)
	if [[ ! -e "$FILE_1" ]]; then
            echo "Error: '$FILE_1' does not exist."
            echo "$(date) - Failed to rename '$FILE_1' (not found)." >> "$LOG_FILE"
        elif [[ -e "$FILE_2" ]]; then
            echo "Error: '$FILE_2' already exists. Cannot overwrite."
            echo "$(date) - Failed to rename '$FILE_1' to '$FILE_2' (destination exists)." >> "$LOG_FILE"
        else
            mv "$FILE_1" "$FILE_2"
            echo "Renamed '$FILE_1' to '$FILE_2' successfully."
            echo "$(date) - Renamed file '$FILE_1' to '$FILE_2'." >> "$LOG_FILE"
        fi
	;;
    *)
        echo "Usage: ./file_manager.sh {create|delete|list|rename} [filename] [new_filename]"
        ;;
esac
