#!/usr/bin/env bash

# create regex for directories
# check for characters invalid in directory names
# how to check if sth exists in bash


help() {
	echo "${0} creates a compressed backup of a user specified directory"
	echo "Usage: "
	echo -e "${0} backup\n"
	# echo "Example usage: ./backup.sh my_pictures pic_backup"


	echo "${0} help: Displays this help message"
}


backup() {
    local dir_name
    local backup_name
	local backup_date=$(date "+%d-%m-%Y_%H%M%S")


    read -rp "Specify the name of the directory to backup: " dir_name
    read -rp "Specify name of the backup (defaults to dir_name if backup_name is not specified) " backup_name

	if [[ ! -d "${dir_name}" ]]; then
		echo -e "\nError: specified directory does not exist" >&2
	fi
	[[ -z "${backup_name}" ]] && backup_name="${dir_name}_${backup_date}" && echo "backup name not specified: using ${dir_name} instead " >&1
    [[ -d "${dir_name}" ]] && tar -czvf "${backup_name}_${backup_date}.tar.gz" "${dir_name}"


}

# backup "$@" > log

command="$1"
case "$command" in
	"backup")
	backup >> backups.log;;

	*)
	help;;
esac

ps aux | awk  ' BEGIN {"ps aux" | getline ps print head} $8=="R+" {print $8, $11}'