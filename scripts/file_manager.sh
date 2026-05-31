#!/bin/bash
 mkdir -p logs 
case $1 in
    create)
        if [[ -e "$2" ]]; then
            echo "file exists"
        else
            touch "$2"
            echo "created $2" >> logs/file_manager.log
        fi
        ;;
    delete)
        if [[ -e "$2" ]]; then
            rm "$2"
            echo "Deleted $2" >> logs/file_manager.log
        else 
            echo "file not found"
        fi
        ;;
    list)
        ls
        echo "List files" >> logs/file_manager.log
        ;;
    rename)
        if [[ -e "$2" ]] && [[ ! -e "$3" ]]; then
            mv "$2" "$3"
            echo "renamed "$2" to "$3" " >> logs/file_manager.log
        else 
            echo "rename failed"
        fi
        ;; 
    *)
        echo "usage"
        echo "./file_manager.sh create filename"
        echo "./file_manager.sh delete filename"
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename old new"
    ;;
esac
