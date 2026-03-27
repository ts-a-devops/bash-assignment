#!/bin/bash
# scripts/user_info.sh
LOG_FILE="logs/user_info.log"
mkdir -p logs

read -p "Enter your Name: " name
read -p "Enter your Age: " age
read -p "Enter your Country: " country

# Validate Age is numeric
if [[ ! $age =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number." | tee -a "$LOG_FILE"
    exit 1
fi

# Categorize
if [ "$age" -lt 18 ]; then
    cat="Minor"
elif [ "$age" -le 65 ]; then
    cat="Adult"
else
    cat="Senior"
fi

msg="Hello $name from $country! You are categorized as: $cat."
echo "$msg" | tee -a "$LOG_FILE"