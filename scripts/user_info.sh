#!/bin/bash
mkdir -p logs
log_file="logs/user_info.log"

read -p "Enter your Name: " name
read -p "Enter your Age: " age
read -p "Enter your Country: " country

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value." | tee -a "$log_file"
    exit 1
fi

if [ "$age" -lt 18 ]; then
    category="Minor (<18)"
elif [ "$age" -le 65 ]; then
    category="Adult (18-65)"
else
    category="Senior (65+)"
fi

echo "Hello $name from $country. You are categorized as a $category." | tee -a "$log_file"
