#!/bin/bash

# Log File Setup
LOG_FILE="logs/user_info.log"
timestamp=$(date +'%Y-%m-%d %H:%M:%S')

echo "=== USER INFO ===" >> "$LOG_FILE"

# Prompt user for name, age and country
read -p "What is your name? " name
read -p "How old are you? " age
read -p "What country are you from? " country

# Check if any of the input is missing
if [[ -z "$name" ]] || [[ -z "$age" ]] || [[ -z "$country" ]]
then
   echo "[$timestamp] Error: Input is Missing" >> "$LOG_FILE"
   echo "One or more of the inputs is missing. Please, answer all prompts"
   exit 1
fi

# Check if age is numeric
if [[ ! $age =~ ^[0-9]+$ ]]
then
    echo "[$timestamp] Error: Non-Numeric input for age" >> "$LOG_FILE"
    echo "Please, enter a numeric input for age"
    exit 1
fi

# Output greeting message to user
echo "[$timestamp] Hello $name, Trust you're doing fine today. It's good to know you're from $country" >> "$LOG_FILE"

# Output age category
if [[ "$age" -lt 18 ]]
then
    echo "[$timestamp] You are a minor as you're less than 18 years." >> "$LOG_FILE"
elif [[ "$age" -ge 65 ]]
then
    echo "[$timestamp] You're $age years old. You are a senior" >> "$LOG_FILE"
else
    echo "[$timestamp] You are $age years old. You're an Adult!" >> "$LOG_FILE"
fi

echo "=== Script Completed ===" >> "$LOG_FILE"
echo "Script Completed and logged successfully. Check $LOG_FILE to view the results"
