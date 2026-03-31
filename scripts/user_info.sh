#!/bin/bash
LOG_FILE="../logs/user_info.log"
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# validate name
if [[ -z "$name" ]]; then
    echo "Error: Name cannot be empty."
    exit 1
fi
# validate age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
    exit 1
fi
#validate country
if [[ -z "$country" ]]; then
    echo "Error: Country cannot be empty."
    exit 1
fi

# Determine age category
if [[ "$age" -lt 18 ]]; then
    category="Minor"
elif [[ "$age" -le 65 ]]; then
    category="Adult"
else
    category="Senior"
fi

#greeting message
message="Hello $name! You are $age years old, a $category from $country."

# display message
echo "$message"
mkdir -p $(dirname "$LOG_FILE")
echo "$(date): $message" >> "$LOG_FILE"
echo "Output saved to $LOG_FILE"
