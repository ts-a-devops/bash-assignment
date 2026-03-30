#!/bin/bash

# This script will display the user information


# Save output to:

# Create the logs directory if it doesn't exist
mkdir -p logs
# spacify our log file for user info
LOG_FILE="logs/user_info.log"

# Prompting users for their information
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# check if name is empty
while [ -z "$name" ]; do
    echo "Invalid name. Please enter a name."
    read -p "Enter your name: " name
done

# check if age is numeric
while ! [[ "$age" =~ ^[0-9]+$ ]]; do
    echo "Invalid age. Please enter a number."
    read -p "Enter your age: " age
done

# check if country is empty
while [ -z "$country" ]; do
    echo "Invalid country. Please enter a country."
    read -p "Enter your country: " country
done

# output  a greeting
greeting="Hello, $name! You are $age years old and from $country."
echo "$greeting" | tee -a "$LOG_FILE"

# output age category
if [ "$age" -lt 18 ]; then
    echo "You are a minor." | tee -a "$LOG_FILE"
elif [ "$age" -gt 18 ] && [ "$age" -lt 65 ]; then
    echo "You are an adult." | tee -a "$LOG_FILE"
else
    echo "You are a senior." | tee -a "$LOG_FILE"
fi

# Add a timestamp so you know when it was saved
echo "--- Saved on $(date) ---" >> "$LOG_FILE"