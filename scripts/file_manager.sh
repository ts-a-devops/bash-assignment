#!/bin/bash


LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/file_manager.log"

if [[ $# -lt 2 ]]; then
	echo "Usage: $0 {create|delete|list|rename} <file> [new_name]" | tee -a "LOG_FILE"
	exit 1
fi

COMMAND=$1
FILE=$2
NEW_NAME=$3

case "$COMMAND" in
	create)
		if [[ -e "$FILE" ]]; then
			echo "Error: $FILE already exists." | tee -a "$LOG_FILE"
		else
			touch "$FILE"
			echo "$FILE created." | tee -a "$LOG_FILE"
		fi
		;;
	delete)
		if [[ -e "$FILE" ]]; then
			rm "$FILE"
			echo "$FILE deleted." | tee -a "$LOG_FILE"
		else
			echo "Error: $FILE does not exist." | tee -a "$LOG_FILE"
		fi
		;;
	list)
		if [[ -d "$FILE" ]]; then
			echo "Listing files in $FILE:" | tee -a "$LOG_FILE"
			ls -l "$FILE" | tee -a "$LOG_FILE"
		else
			echo "Listing current directory:" | tee -a "$LOG_FILE"
			ls -l | tee -a "$LOG_FILE"
		fi
		;;
	rename)
		if [[ -z "$NEW_NAME" ]]; then
			echo "Error: Please provide a new name for this file." | tee -a "$LOG_FILE"
		elif [[ ! -e "$FILE" ]]; then
			echo "Error: $FILE does not exist ." | tee -a "$LOG_FILE"
		elif [[ -e "NEW_NAME" ]]; then
			echo "Error: $NEW_NAME already exists." | tee -a "$LOG_FILE"
		else 
			mv "$FILE" "$NEW_NAME"
			echo "$FILE renamed to $NEW_NAME." | tee -a "$LOG_FILE"
		fi
		;;
	*)
		echo "Unknown command: $COMMAND" | tee -a "$LOG_FILE"
		echo "Usage: $0 {create|delete|list|rename} <file> [new_name]"
		exit 1
		;;
esac
