#!/bin/bash

# A script to collect user information and categorize age.
# Logs output to logs/user_info.log

LOG_FILE="logs/user_info.log"
mkdir -p logs

echo "--- User Info Collection ---"
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age
if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value." | tee -a "$LOG_FILE"
    exit 1
fi

# Categorize age
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

# Output and Log
output="Greeting $name from $country! You are $age years old, which makes you an $category."
echo "$output"
echo "$(date '+%Y-%m-%d %H:%M:%S') - $output" >> "$LOG_FILE"
