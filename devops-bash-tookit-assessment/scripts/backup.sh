#!bin/bash/

LOG_DIR="logs"
BACKUP_DIR="backups"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p $LOG_DIR
mkdir -p $BACKUP_DIR

 SOURCE_DIR=$1

 if [[-z "$SOURCE_DIR"]]; then
	 echo "Error: Provide a directory to backup"
	 exit 1
fi

if [[ ! -d "$SOURCE_DIR"]]; then
	echo "Error: Directory does not exist"
	exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

#Create backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[$?-eq 0]]; then
	echo "Backup created: $BACKUP_FILE"
	echo "$(date): Backup successful - $BACKUP_FILE >> $LOG_FILE"

else
	echo "Backup failed!"
	echo "$(date): Backup failed" >> $LOG_FILE
	exit 1
fi
#Keep only last 5 backups
cd $BACKUP_DIR
ls -t | tail -n +6 | xargs -r rm --

echo "Old backups cleaned up" >> ../$LOG_FILE
