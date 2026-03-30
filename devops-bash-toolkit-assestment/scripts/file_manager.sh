#!/bin/bash

COMMAND=$1
ARG1=$2
ARG2=$3

cd logs
touch file_manager.log


case $COMMAND in
    create)
        if [[ -z $ARG1 ]]; then
            echo "Please provide a filename"
        else
            touch $ARG1 
            echo "File successfully created" >> file_manager.log
        fi
        ;;
    delete)
        if [[ -z $ARG1 ]]; then
            echo "Please provide a filename"
        elif [[ ! -f $ARG1 ]]; then
            echo "File "${ARG1}"does not exist"
        else
            rm $ARG1
            echo "File deleted successfully" >> file_manager.log
        fi
        ;;
    list)
        ls -al
        echo "File listed successfully" >> file_manager.log
        ;;
    rename)
        if [[ -z $ARG1 && $ARG2 ]]; then
            echo "Please provide old filename and new filename"
        elif [[ ! -f $ARG1 ]]; then
            echo "File "${ARG1}"does not exist"
        else
            mv $ARG1 $ARG2 
            echo "File renamed successfully" >> file_manager.log
        fi
        ;;
esac



