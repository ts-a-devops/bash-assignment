#!/bin/bash

mkdir -p logs

action=$1
file=$2

case $action in
    create)
        if [[ -f $file ]]; then
            echo "File already exists"
        else
            touch $file
            echo "Created $file" >> logs/file_manager.log
        fi
        ;;
    delete)
        rm -f $file
        echo "Deleted $file" >> logs/file_manager.log
        ;;
    list)
        ls
        ;;
    rename)
        newname=$3
        mv $file $newname
        echo "Renamed $file to $newname" >> logs/file_manager.log
        ;;
    *)
        echo "Invalid command"
        ;;
esac
