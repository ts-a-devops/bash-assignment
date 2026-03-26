#!/bin/bash

# 1. Create a new directory called "my_files"
mkdir -p my_files

# 2. Create 3 empty text files inside that folder
touch my_files/file1.txt my_files/file2.txt my_files/file3.txt

echo "Created 3 files in the 'my_files' folder."

# 3. Rename the files to have 'processed_' at the start
# We use a 'loop' to do this for all 3 files at once!
for file in my_files/*.txt; do
    mv "$file" "my_files/processed_$(basename "$file")"
done

echo "Files have been renamed successfully!"

# 4. List the files so we can see the result
ls my_files