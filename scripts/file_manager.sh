#!/bin/bash
# file_manager.sh - File management utility
# Written by Dave Woks

set -uo pipefail

mkdir -p ~/bash-assignment/logs
LOGFILE=~/bash-assignment/logs/file_manager.log

log_action() {
    echo "[$(date +%F\ %T)] $1" >> "$LOGFILE"
}

COMMAND=$1
TARGET=$2

if [[  $# -lt 2 ]]; then 
    echo "Usage: ./file_manager.sh [create|delete|list|rename] [filename]"
    exit 1
fi

case $COMMAND in
    create)
        if [[ -f "$TARGET" ]]; then
            echo "Error: $TARGET already exists."
            log_action "Error: Create failed, $TARGET already exists."
            exit 1
        fi
        touch "$TARGET"
        echo "Created: $TARGET"
	log_action "Create file: $TARGET"
        ;;
    delete)
        if  [[ ! -f "$TARGET" ]]; then
            echo "Error: $TARGET does not exist."
	    log_action "Error: Delete failed, $TARGET not found."
	    exit 1
        fi
	rm "$TARGET"
	echo "Deleted: $TARGET"
	log_action "Deleted file: $TARGET"
	;;
    list)
	echo "Files in $TARGET:"
	ls -la "$TARGET"
	log_action "Listed directory: $TARGET"
	;;
    rename)
	if [[ $# -lt 3 ]]; then
	    echo "Usage: ./file_manager.sh rename [oldname] [newname]"
	    exit 1
	fi
	NEWNAME=$3
	if [[ ! -f "$TARGET" ]]; then
	    echo "Error: $TARGET does not exist."
	    log_action "Error: Rename failed, $TARGET not found."
	    exit 1
	fi
	mv "$TARGET" "$NEWNAME"
	echo "Renamed: $TARGET to $NEWNAME"
	log_action "Renamed: $TARGET to $NEWNAME"
	;;

    *)
	echo "Invalid command. Use: create, delete, list, rename"
	log_action "ERROR: Invalid command: $COMMAND"
	exit 1
	;;
esac
