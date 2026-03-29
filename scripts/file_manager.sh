#!/bin/bash

mkdir -p logs
LOG_FILE="logs/file_manager.log"

action=$1
file1=$2
file2=$3

case $action in
    create)
        if [[ -f $file1 ]]; then
            echo "File exists"
        else
            touch $file1
            echo "Created $file1"
        fi
        ;;
    delete)
        rm -f $file1
        echo "Deleted $file1"
        ;;
    list)
        ls
        ;;
    rename)
        mv $file1 $file2
        echo "Renamed"
        ;;
    *)
        echo "Invalid command"
        ;;
esac
