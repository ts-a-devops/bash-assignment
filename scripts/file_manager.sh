 #!/bin/bash
 
 LOG_DIR="../logs"
 LOG_FILE="$LOG_DIR/file_manager.log"

 mkdir -p "$LOG_DIR"

 action=$1
 target=$2
 new_name=$3

 log() {
	 echo "$(date): $1" >> "$LOG_FILE"
 }

 case "$action" in
	 create)
		 if [[ -f "$target" ]]; then
			 echo "File already exists."
		 else
			 touch "$target"
			 echo "File created: $target"
			 log "Created file $target"
		 fi
		 ;;
	  
	 delete)
		 if [[ -f "$target" ]]; then
			 rm "$target"
			 echo "File deleted: $target"
			 log "Deleted file"
		 else 
			 echo "File does not exist."
		 fi
		 ;;

	 list)
		 ls -l
		 log "Listed files"
		 ;;

	 rename)
		 if [[ -f "$target" && -n "new_name" ]]; then
			 mv "$target" "$new_name"
			 echo "Renamed to $new_name"
			 log "Renamed $target to $new_name"
		 else
			 echo "Invalid rename operation"
		 fi
		 ;;
	 *)
		 echo "Usage: $0 {create|delete|list|raname} filename [newname]"
		 ;;
 esac

