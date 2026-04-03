#!/bin/bash

echo "Before creating folder_1 and file_1"
ls

# to create a directory and file
mkdir folder_1
touch file_1

echo "After creating folder_1 and file_1"
ls

# to rename directory and  file
mv folder_1 tsfolder
mv file_1 tsfile

echo "After renaming folder_1 and file_1"
ls


#deleting dir and file
rm -rf tsfolder
rm -f tsfile
echo "After removing tsfolder and tsfile"
ls
