#!/bin/bash

# Exit on error
set -e

# Function: show usage
usage() {
    echo "Usage:"
    echo "  $0 create <filename>"
    echo "  $0 delete <filename>"
    echo "  $0 list"
    echo "  $0 rename <oldname> <newname>"
    exit 1
}

# Ensure at least one argument
[[ $# -lt 1 ]] && usage

command="$1"
file="$2"
newfile="$3"

case "$command" in

    create)
        [[ -z "$file" ]] && { echo "Error: filename required"; exit 1; }

        if [[ -e "$file" ]]; then
            echo "Error: '$file' already exists"
        else
            touch "$file"
            echo "✔ Created: $file"
        fi
        ;;

    delete)
        [[ -z "$file" ]] && { echo "Error: filename required"; exit 1; }

        if [[ ! -e "$file" ]]; then
            echo "Error: '$file' does not exist"
        else
            rm -i "$file"
        fi
        ;;

    list)
        echo "📂 Files in $(pwd):"
        ls -lh --group-directories-first
        ;;

    rename)
        [[ -z "$file" || -z "$newfile" ]] && {
            echo "Error: provide old and new filenames"
            exit 1
        }

        if [[ ! -e "$file" ]]; then
            echo "Error: '$file' does not exist"
        elif [[ -e "$newfile" ]]; then
            echo "Error: '$newfile' already exists"
        else
            mv "$file" "$newfile"
            echo "✔ Renamed: $file → $newfile"
        fi
        ;;

    *)
        echo "Error: invalid command '$command'"
        usage
        ;;
esac
