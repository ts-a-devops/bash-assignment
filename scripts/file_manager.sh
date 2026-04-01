#!/bin/bash

mkdir -p ../logs

echo "File Manager"
echo "1. Create File"
echo "2. Delete File"
echo "3. List Files"
echo "4. Rename File"
echo "5. Exit"

read -p "Choose an option: " choice

case $choice in
    1)
        read -p "Enter file name to create: " filename
        if [ -e "$filename" ]; then
            echo "File already exists!"
        else
            touch "$filename"
            echo "Created: $filename" >> ../logs/file_manager.log
        fi
        ;;
    2)
        read -p "Enter file to delete: " file
        rm -i "$file"
        echo "Deleted: $file" >> ../logs/file_manager.log
        ;;
    3)
        ls
        echo "Listed files" >> ../logs/file_manager.log
        ;;
    4)
        read -p "Enter current file name: " old
        read -p "Enter new file name: " new
        
        if [ ! -e "$old" ]; then
        echo "Error; File does not exist!"
        echo "Failed rename attempt: $old to $new" >> ../logs/file_manager.log

        elif [ -e  "$new" ]; then
        echo  "Error; A file with the new name already exists!"
        echo "Failed rename attempt: $old to $new" >> ../logs/file_manager.log

        else
        mv "$old" "$new"
        echo "Renamed: $old to $new" >> ../logs/file_manager.log
        echo "File renamed successfully"
        fi
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option"
        ;;
esac
