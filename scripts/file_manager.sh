#!/usr/bin/env bash

mkdir -p logs

action=$1
file=$2

case $action in
create)
if [ -e "$file" ]; then
echo "File exists"
else
touch "$file"
echo "Created $file" >> logs/file_manager.log
fi
;;
delete)
rm -f "$file"
echo "Deleted $file" >> logs/file_manager.log
;;
list)
ls
;;
rename)
mv "$2" "$3"
echo "Renamed $2 to $3" >> logs/file_manager.log
;;
*)
echo "Invalid command"
;;
esac