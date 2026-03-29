#!/bin/bash
LOG_FILE="logs/user_info.log"

mkdir -p logs

log_output() {
     echo "$1" | tee -a "$LOG_FILE"
    }

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your Country: " country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
	 echo "Error: All fields are required."
	 exit 1

fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
    exit 1
fi

if [ "$age" -lt 18 ]; then
	category="Minor"
elif [ "$age" -le 65 ]; then
	category="Adult"
else
	category="Senior"
fi

message="Hello $name from $country. You are a $category."

echo "$message"

echo "$(date): $message" >> "LOG_FILE"
	
