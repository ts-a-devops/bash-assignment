#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
LOG_FILE="logs/user_info.log"

# Get user input
read -rp "Enter your name: " name
read -rp "Enter your age: " age
read -rp "Enter your country: " country

# Validate input
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  echo "Error: All fields are required." | tee -a "$LOG_FILE"
  exit 1
fi

# Check if age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a number." | tee -a "$LOG_FILE"
  exit 1
fi

# Determine age category
if (( age < 18 )); then
  category="Minor"
elif (( age < 65 )); then
  category="Adult"
else
  category="Senior"
fi

# Output result
message="Hello $name from $country. You are $age years old ($category)."
echo "$message"
echo "$(date '+%F %T') - $message" >> "$LOG_FILE"
