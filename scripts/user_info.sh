#!/bin/bash

# Log file (relative to scripts folder)
LOG_FILE="../logs/user_info.log"

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validation
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  echo "Error: All fields are required." | tee -a "$LOG_FILE"
  exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be numeric." | tee -a "$LOG_FILE"
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

# Prepare message
message="Hello $name from $country! You are an $category."

# Display and log message
echo "$message" | tee -a "$LOG_FILE"
