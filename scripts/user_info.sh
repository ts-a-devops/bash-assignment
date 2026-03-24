#!/bin/bash
set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

LOG_FILE="logs/user_info.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Input with validation
read -p "Enter name: " name
if [[ -z "$name" ]]; then
    echo "Error: Name cannot be empty" >&2
    exit 1
fi

read -p "Enter age: " age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be numeric" >&2
    exit 1
fi

read -p "Enter country: " country
if [[ -z "$country" ]]; then
    echo "Error: Country cannot be empty" >&2
    exit 1
fi

# Determine category
if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

# Output and log
log "Hello $name from $country. Category: $category"
