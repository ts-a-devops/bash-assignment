#!/bin/bash
set -euo pipefail
LOG_FILE="logs/file_manager.log"
mkdir -p logs
log() {
echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}
command=${1:-}
case "$command" in
create)
filename=${2:-}
if [[ -z "$filename" ]]; then
echo "Error: Filename required"
exit 1
fi
if [[ -e "$filename" ]]; then
echo "Error: File already exists"
exit 1
fi
touch "$filename"
echo "File created: $filename"
log "Created file: $filename"
;;
delete)
filename=${2:-}
if [[ -z "$filename" ]]; then
echo "Error: Filename required"
exit 1
fi
if [[ ! -e "$filename" ]]; then
echo "Error: File does not exist"
exit 1
fi
rm "$filename"
echo "File deleted: $filename"
log "Deleted file: $filename"
;;
list)
ls -lh
log "Listed files"
;;
rename)
old=${2:-}
new=${3:-}
if [[ -z "$old" || -z "$new" ]]; then
echo "Error: old and new filenames required"
exit 1
fi
if [[ ! -e "$old" ]]; then
echo "Error: File does not exists"
exit 1
fi
if [[ -e "$new" ]]; then 
echo "Error: Target file already exists"
exit 1
fi
mv "$old" "$new"
echo "Renamed $old to $new"
log "Renamed $old to $new"
;;
*)
echo "Usage: $0 {create|delete|list|rename}"
exit 1
;;
esac
