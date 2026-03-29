G_FILE="../logs/file_manager.log"
mkdir -p ../logs

ACTION=$1
FILE1=$2
FILE2=$3

log_action() {
    echo "$(date): $1" >> "$LOG_FILE"
}

case "$ACTION" in

    create)
        if [[ -z "$FILE1" ]]; then
            echo "Error: No filename provided."
            exit 1
        fi

        if [[ -e "$FILE1" ]]; then
            echo "Error: File already exists."
            exit 1
        fi

        touch "$FILE1"
        echo "File '$FILE1' created."
        log_action "Created file $FILE1"
        ;;

    delete)
        if [[ ! -e "$FILE1" ]]; then
            echo "Error: File does not exist."
            exit 1
        fi

        rm "$FILE1"
        echo "File '$FILE1' deleted."
        log_action "Deleted file $FILE1"
        ;;

    list)
        ls -lh
        log_action "Listed files"
        ;;

    rename)
        if [[ ! -e "$FILE1" ]]; then
            echo "Error: Source file does not exist."
            exit 1
        fi

        if [[ -e "$FILE2" ]]; then
            echo "Error: Target file already exists."
            exit 1
        fi

        mv "$FILE1" "$FILE2"
        echo "Renamed '$FILE1' to '$FILE2'."
        log_action "Renamed $FILE1 to $FILE2"
        ;;

    *)
        echo "Usage:"
        echo "./file_manager.sh create <filename>"
        echo "./file_manager.sh delete <filename>"
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename <oldname> <newname>"
        exit 1
        ;;

esac


