#!/bin/bash

#Anchor to this script's location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/.."

# Accept log path from run_all.sh, or fall back to default
LOG_FILE="${1:-$BASE_DIR/logs/user_info.log}"

mkdir -p "$(dirname "$LOG_FILE")"

echo "Enter your name:"
read name

echo "Enter your age:"
read age

echo "Enter your country:"
read country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
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

# Output message
message="Hello $name from $country! You are a $category."
echo "$message"

# Save to log
echo "$(date): $message" >> "$LOG_FILE"i
