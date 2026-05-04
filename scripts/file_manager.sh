#!/bin/bash
# Check the following actions run with this scrips

action=$1
filename=$2

# Using a case statement to check each action and possibility.
case $action in
    create)
        if [ -e $filename ]; then
            echo "File already exists."
        else
            touch "$filename"
            echo "File has been created."
        fi
        ;; 
    delete)
        if [ -e $filename ]; then
            rm "$filename"
            echo "$filename has been deleted"
        else 
            echo "$filename does not exist"
        fi
        ;;
    list)
        if [ -e $filename ]; then
            ls
        else 
            echo "$filename does not exist"
        fi
        ;;
    rename)
        if [ -e $filename ]; then 
            mv "$filename" "temp_file.tx"
            echo "$filename has been renamed to temp_file"
        else
            echo "Failed to rename file"
        fi
        ;;
    *)
        echo "Unkown action: try: ./file_manager.sh {create} {delete} {list}"
        ;;
esac  


