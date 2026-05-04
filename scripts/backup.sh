#!/bin/bash

# Back up file Scripts directory
# Today's Timestam
timestamp=$(date +%d-%m-%y)

# Path to target directory to be backed up
target_dir='/home/gege/devops-bash-toolkit-assestment/scripts'

# Path to destination directory
destination_dir='/home/gege/scripts_backup_'$timestamp'.tar.gz'

# Accept directory as input
if [[ ! -d $1 ]] then
    echo "Argument is not a directory."
    exit
else 
    cp -r ${target_dir} ${destination_dir}
fi

 

