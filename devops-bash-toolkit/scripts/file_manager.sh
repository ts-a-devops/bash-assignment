#!/bin/bash

action=$1
file=$2
newname=$3
log="../logs/file_manager.log"

case $action in 
    create)
    if [[ -e "$file" ]]; then
        echo "File exist"
    else
        touch $file
    	echo "$file created" > $log
    fi
    ;;

    delete)
    rm $file
        echo "$file deleted" > $log
        ;;
    list)
    ls
    ;;
    rename)
    mv "$file" "$newname"
    echo "Renamed "$file" to "$newname" " > $log
    ;;
    *)
    echo "Invalid Command"
esac
