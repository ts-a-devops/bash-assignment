# Accept a directory as input
# Validate that the directory exists
# Create a compressed backup: backup_<timestamp>.tar.gz
# Keep only the last 5 backups (delete older ones)

echo "==================================="
echo "Running Script"
echo "==================================="


# check and ccreate backups
if [ -d "../backups" ]; then
        echo
else
	mkdir -p "../backups"
fi
 
usage="Usage: $0 <directory_to_backup>"
timestamp="$USER:$(date '+%Y-%m-%d %H:%M:%S')"
date="$(date '+%Y-%m-%d_%H-%M-%S')"
targetDir=$(basename "$1")
parentDir=$(dirname "$1")

if [[ $# -gt 1 ]]; then 
	echo "Too Many Arguments"
	echo $usage
	echo -e "$timestamp [Error] - Too Many Arguments. \n$usage" >> ../logs/backup.log 
elif [[ ! -d "$1" ]]; then
	echo "$1 is not a valid directory or do not exist. \ntry again"
	echo -e "$timestamp [Error] - $1 is not a valid directory or do not exist. \ntry again" >> ../logs/backup.log
        exit 1	
else 
	tar -czf "../backups/backup_$date.tar.gz" -C "$parentDir" "$targetDir"
	echo -e "$timestamp [Success] - Backup successful " >> ../logs/backup.log
fi

echo "Cleaning up old backups..."
ls -t "../backups"/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm
echo  echo -e "$timestamp [Info] - Cleared Up old backups " >> ../logs/backup.log

echo "==================================="
echo "Script completed successfully"
echo "Valar Dohaeris"
echo "==================================="
