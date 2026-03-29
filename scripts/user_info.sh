#!/bin/bash

LOG_FILE="logs/user_info.log"

# Create logs directory if it doesn't exist
mkdir -p logs

# Function to log messages
log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Prompt for user input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

echo ""

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    log_message "Error: All fields (name, age, country) are required."
    exit 1
fi

# Check if age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    log_message "Error: Age must be a numeric value."
    exit 1
fi

# Determine age category
if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

# Output greeting
message="Hello $name from $country! You are an $category."

log_message "$message"
