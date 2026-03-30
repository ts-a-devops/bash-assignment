#!/bin/bash

LOG_FILE="../logs/user_info.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log messages
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

# Collect user input
read -rp "Enter your name: " name
read -rp "Enter your age: " age
read -rp "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  log "Error: All fields are required"
  exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  log "Error: Age must be numeric"
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

# Generate and log message
message="Hello $name from $country! You are an $category."
log "$message"
