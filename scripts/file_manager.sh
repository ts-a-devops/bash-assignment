#!/bin/bash

case $1 in
    create)
        touch "$2"
        echo "File '$2' created."
        ;;

    delete)
        rm "$2"
        echo "File '$2' deleted."
        ;;

    list)
        ls -l
        ;;

    rename)
        mv "$2" "$3"
        echo "File '$2' renamed to '$3'."
        ;;

    *)
        echo "Usage:"
        echo "$0 create <filename>"
        echo "$0 delete <filename>"
        echo "$0 list"
        echo "$0 rename <oldname> <newname>"
        ;;
esac
