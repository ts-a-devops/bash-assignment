#!/bin/bash
set -euo pipefail
LOG_FILE="logs/user_info.log"
mkdir -p logs
log() {
echo "$(date '+%Y-%m-%d %H:%M:%S') -$1" >> "$LOG_FILE"
}
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country
#VALIDATION
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
echo "Error: All fields are required."
exit 1
fi
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
echo "Error: Age must must be numeric."
exit 1
fi
# AGE CATEGORY
if ((age<18)); then
category="Minor"
elif ((age<=65)); then
category="Adult"
else
category="Senior"
fi
message="Hello $name from $country. You are an $category."
echo "$message"
log "$message" 
