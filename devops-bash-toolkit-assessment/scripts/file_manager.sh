#!/bin/bash

LOG_FILE="../logs/file_manager.log"

COMMAND=$1
FILENAME=$2
if [[ -z "${COMMAND}" ]]; then
    echo "Usage: $0 {create|delete|list|rename} <filename>" | tee -a "${LOG_FILE}"
    exit 1
fi

case ${COMMAND} in
    "create")
	    if [ -f "${FILENAME}" ]; then
		    echo "Error: ${FILENAME} already exists!" | tee -a "${LOG_FILE}"
	    else
		    touch "${FILENAME}"
		    echo "Created file: ${FILENAME}" | tee -a "${LOG_FILE}"
	    fi
	    ;;
    "delete")
	    if [ ! -f "${FILENAME}" ]; then
		    echo "Error: ${FILENAME} does not exist!" | tee -a "${LOG_FILE}"
	    else
		    rm "${FILENAME}"
		    echo "Deleted file: ${FILENAME}" | tee -a "${LOG_FILE}"
	    fi
	    ;;
    "list")
	    ls -F | tee -a "${LOG_FILE}"
	    ;;
    "rename")
	    NEWNAME=$3
	    if [ ! -f "${FILENAME}" ]; then
		    echo "Error: ${FILENAME} does not exist!" | tee -a "${LOG_FILE}"
	    elif [ -z "${NEWNAME}" ]; then
		    echo "Error: new name not provided!" | tee -a "${LOG_FILE}"
	    else
		    mv "${FILENAME}" "${NEWNAME}"
		    echo "Renamed ${FILENAME} to ${NEWNAME}" | tee -a "${LOG_FILE}"
	    fi
	    ;;
    *)
	    echo "Error: Unknown command '${COMMAND}'. Use: create, delete, list, rename" | tee -a "${LOG_FILE}"
	    exit 1
	    ;;
esac
