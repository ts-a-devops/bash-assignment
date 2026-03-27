#!/bin/bash

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"

mkdir -p "$LOG_DIR"

log_message() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" | tee -a "$LOG_FILE"
}

validate_age() {
    local age=$1
    if ! [[ "$age" =~ ^[0-9]+$ ]]; then
        return 1
    fi
    return 0
}

get_age_category() {
    local age=$1
    if [ "$age" -lt 18 ]; then
        echo "Minor"
    elif [ "$age" -le 65 ]; then
        echo "Adult"
    else
        echo "Senior"
    fi
}

main() {
    log_message "=== User Info Script Started ==="
    
    read -p "Enter your name: " name
    if [ -z "$name" ]; then
        log_message "ERROR: Name cannot be empty"
        echo "Error: Name is required. Exiting."
        exit 1
    fi
    
    while true; do
        read -p "Enter your age: " age
        if [ -z "$age" ]; then
            echo "Error: Age cannot be empty. Please try again."
            continue
        fi
        
        if validate_age "$age"; then
            break
        else
            echo "Error: Age must be a valid number. Please try again."
        fi
    done
    
    read -p "Enter your country: " country
    if [ -z "$country" ]; then
        log_message "WARNING: Country not provided"
        country="Not specified"
    fi
    
    category=$(get_age_category "$age")
    
    echo ""
    echo "========================================"
    echo "  Hello, $name!"
    echo "  You are $age years old ($category)"
    echo "  Location: $country"
    echo "========================================"
    
    log_message "User: $name, Age: $age ($category), Country: $country"
    log_message "=== User Info Script Completed ==="
}

main "$@"
