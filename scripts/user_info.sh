#!/bin/bash
# user_info.sh - Collect user information with validation

LOG_FILE="logs/user_info.log"
mkdir -p logs

# Prompt user
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validation
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
	echo "Error: Age must be a number."
	exit 1
fi

# Age category
if [ "$age" -lt 18 ]; then
	category="Minor"
elif [ "$age" -le 65 ]; then
	category="Adult"
else
	category="senior"
fi

# Greeting
greeting="Hello $name from $country! You are categorized as: $category."

echo "$greeting"

# Log to file with timestamp
echo "$(date '+%Y-%m-%d %H:%M:%S') - $greeting" >> "$LOG_FILE"
