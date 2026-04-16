#!/bin/bash
mkdir -p ../logs
LOG_FILE="../logs/user_info.log"
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
echo "Error: ALL FIELDS ARE REQUIRED!"
exit 1
fi
if  ! [[ "$age" =~ ^[0-9]+$ ]]; then
echo "Error: AGE MUST BE A NUMBER!"
exit 1
fi
if (( age < 18 )); then
category="minor"
elif (( age <= 65 )); then
category= "Adult"
else
category= "senior"
fi
message="Hello $name from $country. you are $age years old ($category)."
echo "$message"
echo "$(date): $message" >> "$LOG_FILE"
