#!/bin/bash
# user_info.sh - Collect user info with validation and logging

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/user_info.log"
mkdir -p "$LOG_DIR"

echo "=== User Information Collection ==="

# Prompt for inputs
read -rp "Enter your name: " name
read -rp "Enter your age: " age
read -rp "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required." >&2
    exit 1
fi

# Age must be numeric and non-negative
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a positive number." >&2
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

# Greeting message
greeting="Hello, $name from $country! You are $age years old and classified as a $category."

echo "$greeting"
echo "$(date '+%Y-%m-%d %H:%M:%S') - $greeting" >> "$LOG_FILE"

echo "User info saved to $LOG_FILE"



