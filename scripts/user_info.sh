#!/bin/bash

# user_info.sh - Collects user information and categorizes by age

# Create logs directory if it doesn't exist
mkdir -p logs

LOG_FILE="logs/user_info.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_message "Script started"

# Prompt for user information
echo "=== User Information Collector ==="
read -p "Enter your name: " name

# Validate name is not empty
if [[ -z "$name" ]]; then
    echo "Error: Name cannot be empty"
    log_message "Error: Name was empty"
    exit 1
fi

read -p "Enter your age: " age

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value"
    log_message "Error: Invalid age input - $age"
    exit 1
fi

read -p "Enter your country: " country

# Validate country is not empty
if [[ -z "$country" ]]; then
    echo "Error: Country cannot be empty"
    log_message "Error: Country was empty"
    exit 1
fi

# Determine age category
if (( age < 18 )); then
    category="Minor"
elif (( age >= 18 && age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

# Display greeting and information
echo ""
echo "=========================================="
echo "Hello, $name!"
echo "Age: $age years"
echo "Country: $country"
echo "Category: $category"
echo "=========================================="
echo ""

# Log the information
log_message "Name: $name | Age: $age | Country: $country | Category: $category"
log_message "Script completed successfully"

echo "✓ Information saved to $LOG_FILE"

