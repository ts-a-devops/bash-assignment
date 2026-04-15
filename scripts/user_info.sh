#!/bin/bash

set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

# Redirect all output to both terminal and log file
exec > >(tee -a logs/user_info.log) 2>&1

# Prompt for user info
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number." >&2
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

# Output greeting
echo "Hello $name from $country! You are an $category ($age years old)."


