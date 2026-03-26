#!/bin/bash
ACTION=$1
FNAME=$2

case "$ACTION" in
    create)
        if [[ -e "$FNAME" ]]; then echo "File exists!"; else touch "$FNAME" && echo "Created $FNAME"; fi
        ;;
    delete)
        rm "$FNAME" && echo "Deleted $FNAME"
        ;;
    list)
        ls -lh
        ;;
    *)
        echo "Usage: $0 {create|delete|list} [filename]"
        ;;
esac
