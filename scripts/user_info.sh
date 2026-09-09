#!/usr/bin/env bash

# Ensure the logs directory exists
mkdir -p "$(dirname "$0")/../logs"
LOG_FILE="$(dirname "$0")/../logs/user_info.log"

# Function to write to terminal and log file simultaneously
log_and_print() {
    echo "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 1. Prompt for user input
read -p "Enter your Name: " name
read -p "Enter your Age: " age
read -p "Enter your Country: " country

# 2. Validate for missing inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: Name, Age, and Country cannot be empty."
    exit 1
fi

# 3. Validate that Age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a positive integer."
    exit 1
fi

# 4. Determine Age Category
if (( age < 18 )); then
    category="Minor (<18)"
elif (( age >= 18 && age <= 65 )); then
    category="Adult (18-65)"
else
    category="Senior (65+)"
fi

# 5. Output and Log
echo "-----------------------------------"
log_and_print "Hello, $name from $country!"
log_and_print "Age: $age ($category)"
echo "-----------------------------------"
echo "Log saved to $LOG_FILE"
