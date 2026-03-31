#!/usr/bin/env bash

LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/user_info.log"

mkdir -p "$LOG_DIR"

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be numeric."
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

message="Hello $name from $country! You are an $category."

echo "$message"
echo "$(date): $message" >> "$LOG_FILE"
