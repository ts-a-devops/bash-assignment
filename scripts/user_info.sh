#!/bin/bash

# Collects user information with validation

set -euo pipefail

LOG_FILE="logs/user_info.log"

mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

is_numeric() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

get_age_category() {
    local age=$1
    if (( age < 18 )); then
        echo "Minor"
    elif (( age >= 18 && age <= 65 )); then
        echo "Adult"
    else
        echo "Senior"
    fi
}

log_message "=== User Info Script Started ==="

read -p "Enter your name: " -r name || { log_message "ERROR: Failed to read name"; exit 1; }

if [[ -z "$name" ]]; then
    log_message "ERROR: Name cannot be empty"
    echo "Error: Name cannot be empty"
    exit 1
fi

read -p "Enter your age: " -r age || { log_message "ERROR: Failed to read age"; exit 1; }

if ! is_numeric "$age"; then
    log_message "ERROR: Age must be numeric (received: $age)"
    echo "Error: Age must be numeric"
    exit 1
fi

read -p "Enter your country: " -r country || { log_message "ERROR: Failed to read country"; exit 1; }

if [[ -z "$country" ]]; then
    log_message "ERROR: Country cannot be empty"
    echo "Error: Country cannot be empty"
    exit 1
fi

age_category=$(get_age_category "$age")

# Output
echo "================================"
echo "Hello, $name!"
echo "Age: $age"
echo "Country: $country"
echo "Age Category: $age_category"
echo "================================"

# Output logs
log_message "User Info Collected - Name: $name, Age: $age, Country: $country, Category: $age_category"
log_message "=== User Info Script Completed ==="

exit 0
