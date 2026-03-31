#!/bin/bash

SOURCE_DIR=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/../backups"
LOG_FILE="${SCRIPT_DIR}/../logs/backup.log"

mkdir -p "${SCRIPT_DIR}/../logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Validate that the directory exists
if [ ! -d "${SOURCE_DIR}" ]; then
    echo "Error: Directory ${SOURCE_DIR} does not exist!" | tee -a "${LOG_FILE}"
    exit 1
fi

# Create backup directory if it doesn't exist
        mkdir -p "${BACKUP_DIR}"
       
# Create compressed backup
        BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"

      	if tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" "${SOURCE_DIR}"; then
	 	echo "Backup of ${SOURCE_DIR} created: ${BACKUP_FILE}" | tee -a "${LOG_FILE}"
    	else
   		echo "Error: Backup failed!" | tee -a "${LOG_FILE}"
		exit 1
	fi
	
# Keep only the last 5 backups
                  ls -t "${BACKUP_DIR}"/backup_*.tar.gz | tail -n +6 | xargs rm -f
		  echo "Cleanup: Kept 5 most recent backups." | tee -a "${LOG_FILE}"
