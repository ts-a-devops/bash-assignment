#!/bin/bash
# Task C: File Manager with Positional Parameters

ACTION=$1
FILENAME=$2

case $ACTION in
    "create")
        touch "$FILENAME" && echo "Created $FILENAME"
        ;;
    "delete")
        rm "$FILENAME" && echo "Deleted $FILENAME"
        ;;
    "rename")
        mv "$FILENAME" "$3" && echo "Renamed $FILENAME to $3"
        ;;
    *)
        echo "Usage: $0 {create|delete|rename} filename [newname]"
        ;;
esac
