#!/bin/bash

# Create logs directory if it does not exist
mkdir -p ../logs

LOG_FILE="../logs/file_manager.log"

ACTION=$1
FILE1=$2
FILE2=$3

echo "[$(date)] Action: $ACTION $FILE1 $FILE2" >> $LOG_FILE

case $ACTION in

create)
    if [ -z "$FILE1" ]; then
        echo "Please provide a file name."
    elif [ -f "$FILE1" ]; then
        echo "File already exists. Cannot overwrite."
    else
        touch "$FILE1"
        echo "File $FILE1 created successfully."
    fi
    ;;

delete)
    if [ -z "$FILE1" ]; then
        echo "Please provide a file name."
    elif [ -f "$FILE1" ]; then
        rm "$FILE1"
        echo "File $FILE1 deleted."
    else
        echo "File does not exist."
    fi
    ;;

list)
    echo "Files in current directory:"
    ls
    ;;

rename)
    if [ -z "$FILE1" ] || [ -z "$FILE2" ]; then
        echo "Usage: ./file_manager.sh rename oldname newname"
    elif [ ! -f "$FILE1" ]; then
        echo "File $FILE1 does not exist."
    else
        mv "$FILE1" "$FILE2"
        echo "File renamed from $FILE1 to $FILE2."
    fi
    ;;

*)
    echo "Invalid command."
    echo "Usage:"
    echo "./file_manager.sh create filename"
    echo "./file_manager.sh delete filename"
    echo "./file_manager.sh list"
    echo "./file_manager.sh rename oldname newname"
    ;;

esac 
