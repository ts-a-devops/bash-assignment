#!/bin/bash

mkdir -p logs
LOG_FILE="logs/user_info.log"

#prompt for name
read -p "Enter your name: " name
[ -z "$name" ] && echo "Name is required" && exit 1

# Prompt for Age
read -p "Enter your age: " age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
	echo "age must be a number" 
	exit 1
fi

# Determine age category

if [ "$age" -lt 18 ]; then
	category="Minor"
elif [ "$age" -le 65 ]; then
	category="Adult"
else 
	cateory="Senior"
fi

#Prompt for country

read -p "Enter your country: " country
[ -z "$country" ] && echo "Country is required" && exit 1


# The Greeting message
message="Hello $name from $country! You are $age years old ($category)."
echo "$message"

# Save to Log
echo "$(date '+%y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"


