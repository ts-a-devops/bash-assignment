#!/usr/bin/env bash


# Function to show usage/help
show_help() {
    echo "Usage: $(basename "$0") [command]"
    echo ""
    echo "Commands:"
    echo "  create [filename]   Create file titled filename with some user-provided extension (e.g .txt)"
    echo "  delete [filename]   Delete specified filename"
    echo "  rename [filename]   Rename file"
    echo "  list  List files in the current directory"
    echo "  help  Show this help message"
}

create() {
    local file_name=${1:?"File name must be specified for creation, exiting...."}

    if [[ -f "$file_name" ]]; then
    echo "File already exists"
    else
    touch -- "$file_name" && echo "File created"

    fi
}
#refactor delete to confirm before deleting a directory
# add error handling for when delete fails
delete() {

    local file_name=${1:?"A file name must be specified for deletion, exiting...."}

    if [[ ! -f "${file_name}"  && ! -d "${file_name}" ]]; then
        echo "No file or directory named ${file_name} found" >&2
        exit
    elif [[ -f "${file_name}" ]]; then
        rm -- -f "${file_name}"

    elif [[ -d "${file_name}" ]]; then
        rm -- -rf "${file_name}"

    fi
}

#

# Function to list files
list() {
    ls -lh
}
# add error handling for when delete fails

rename() {
    local old_name=${1:?"Name of existing file cannot be empty"}
    local new_name=${2:?"New name of existing file cannot be empty"}

    if [[ -e "${old_name}" ]]; then
        mv -- "${old_name}" "${new_name}"
    else
        printf "Error: file \'%s\' does not exist" "$old_name"
    fi
}

# Parse the first argument as the command
command=$1
shift  # remove first argument so $@ contains remaining args

case "$command" in
    create | cr)
    create "$@"
    ;;
    delete | del)
    delete "$@"
    ;;
    list | l)
    list
    ;;
    rename | rn)
    rename "$@"
    ;;
    *)
    show_help
    ;;
esac

