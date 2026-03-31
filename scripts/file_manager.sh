#!/bin/bash

LOG_FILE="../logs/file_manager.log"
mkdir -p ../logs

command=$1
file=$2
newname=$3

case $command in

create)
    if [ -f "$file" ]; then
        echo "File already exists!"
    else
        touch "$file"
        echo "Created $file" >> $LOG_FILE
    fi
    ;;

delete)
    if [ -f "$file" ]; then
        rm "$file"
        echo "Deleted $file" >> $LOG_FILE
    else
        echo "File not found."
    fi
    ;;

list)
    ls
    echo "Listed files" >> $LOG_FILE
    ;;

rename)
    if [ -f "$file" ]; then
        mv "$file" "$newname"
        echo "Renamed $file to $newname" >> $LOG_FILE
    else
        echo "File not found."
    fi
    ;;

*)
    echo "Usage: $0 {create|delete|list|rename}"
    ;;

esac
