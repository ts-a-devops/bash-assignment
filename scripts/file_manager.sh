#!/bin/bash

mkdir -p logs

action=$1
filename=$2
newname=$3

case $action in 
create)
if [ -f "$filename" ]; then
echo "File already exists"
else 
touch "$filename"
echo "File created"
fi
;;

delete)
rm -f "$filename"
echo "File deleted"
;;

list)
ls -l
;;

rename)
mv "$filename" "$newname"
echo "File renamed"
;;

*)
echo "Invalid command"
esac

echo "$(date): $action $filename" >> logs/file_manager.sh
