#!/bin/bash

## Log file location
LOG_FILE="logs/user_info.log"

# Ask user for details
echo "Enter your name:"
read name

echo "Enter your age:"
read age

echo "Enter your country:"
read country

# Check if any input is empty
if [ -z "$name" ] || [ -z "$age" ] || [ -z "$country" ]; then
    echo "Error: All fields are required."
        echo "$(date): Missing input" >> "$LOG_FILE"
  exit 1
fi

# Check if age is a number
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
	echo "Error: Age must be a number."
             echo "$(date): Invalid age entered" >> "$LOG_FILE"
 exit 1
fi

# Determine age category
if [ "$age" -lt 18 ]; then
category="Minor"
elif [ "$age" -le 65 ]; then
category="Adult"
else
category="Senior"
fi

# Output message
message="Hello $name from $country. You are an $category."

echo "$message"
echo "$(date): $message" >> "$LOG_FILE"
