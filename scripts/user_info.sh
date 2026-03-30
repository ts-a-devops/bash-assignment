#!/bin/bash

# ==========================================
# Script: user_info.sh
# Description: Collects user info, validates input,
#              categorizes age, and logs output
# Author: David Igbo
# ==========================================

LOG_FILE="../logs/user_info.log"

# Ensure logs directory exists
mkdir -p ../logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Capitalize first letter of each word in name
name="$(echo "$name" | sed 's/\b./\u&/g')"

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

message="Hello $name from $country! You are classified as an $category."

echo "$message"
echo "$(date): $message" >> "$LOG_FILE"

exit 0
