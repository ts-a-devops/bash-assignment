#!/bin/bash

# 1. Print a welcome message
echo "Starting DevOps Assignment..."

# 2. Create a backup directory if it doesn't exist
mkdir -p backup_folder

# 3. List all files in the current directory and save to a file
ls -la > backup_folder/file_list.txt

# 4. Print the status
echo "Backup folder created and file list saved!"

