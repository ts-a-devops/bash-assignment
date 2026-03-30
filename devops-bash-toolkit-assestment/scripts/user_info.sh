#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"

# Create logs directory
mkdir -p "$LOG_DIR"

# Function to validate numeric age
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# Prompt for Name
read -p "Enter your name: " name

if [ -z "$name" ]; then
    echo "Error: Name cannot be empty."
    exit 1
fi

# Prompt for Age
read -p "Enter your age: " age

if [ -z "$age" ]; then
    echo "Error: Age cannot be empty."
    exit 1
fi

if ! is_number "$age"; then
    echo "Error: Age must be numeric."
    exit 1
fi

# Prompt for Country
read -p "Enter your country: " country

if [ -z "$country" ]; then
    echo "Error: Country cannot be empty."
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

# Greeting message
message="Hello $name from $country. You are $age years old. Category: $category."

echo "$message"

# Save to log file
echo "$(date): $message" >> "$LOG_FILE"
