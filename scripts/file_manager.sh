# Support the following commands: create, delete, list, rename
# Example usage:
# ./file_manager.sh create file.txt
# Prevent overwriting existing files
#

echo "==================================="
echo "Running Script"
echo "==================================="


# check and ccreate logs 
if [ -d "../logs" ]; then
        echo
else
	mkdir -p "../logs"
fi
 


timestamp="$USER:$(date '+%Y-%m-%d %H:%M:%S')"
usage="USAGE: ./file_manager.sh operation filename or Example1: ./file_manager.sh rename oldfile newfile
        \nAllowed operations:
        \n\t- create
        \n\t- delete
        \n\t- list
        \n\t- rename

        \n\nExample1: ./file_manager.sh create file.txt
        \n\nExample1: ./file_manager.sh rename file.txt new_file.txt
        \n\nTry Again"
# check usage
if [[ $# -gt 3 ]]; then 
	echo "Too many Arguments"
	echo -e $usage
fi

# manage files
case $1 in
	"create")
		if [[ ! -f "$2" ]]; then
			touch "$2"
			echo -e "$timestamp - Created a newfile $2" >> ../logs/file_manager.log
		else 
			echo -e "$timestamp - File already exist" >> ../logs/file_manager.log
		fi
		;;
	"delete")
		if [[ -f "$2" ]]; then
			rm "$2"
                        echo -e "$timestamp - Deleted the file $2" >> ../logs/file_manager.log
                else
                        echo -e "$timestamp - File does not exist or already deleted" >> ../logs/file_manager.log
                fi
                ;;
	"list")
		if [[ "$2" ]]; then
                        ls "$2"
                        echo -e "$timestamp - Listed the directory $2" >> ../logs/file_manager.log
			ls "$2"  >> ../logs/file_manager.log
                else
                	ls 
			echo -e "$timestamp - Listed the current directory" >> ../logs/file_manager.log
			ls  >> ../logs/file_manager.log
                fi
                ;;
	"rename")
		if [[ "$2" && "$3" ]]; then
                        mv "$2" "$3"
                        echo -e "$timestamp - Renamed file from $2 to $3" >> ../logs/file_manager.log
                else
                        echo -e "$timestamp - File rename failed" >> ../logs/file_manager.log
			echo -3 $usage
                fi
                ;;
	*)
		echo "Invalid Commaand check \n$usage"  >> ../logs/file_manager.log
		echo -e "Invalid Commaand check \n$usage"
		exit 1
		;;
esac
sleep 1

echo "==================================="
echo "Script completed successsfully"
echo "cat file_manager.log to view the logs"
echo "go back to scripts/ to run the other script"
echo "Valar Mogulis"
echo "==================================="
