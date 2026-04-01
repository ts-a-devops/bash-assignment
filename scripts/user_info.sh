#!/bin/bash
# The line above is called a "shebang"
# It tells the system to run this script using bash

# Create the logs directory if it does not exist
# This prevents errors when trying to save the log file
mkdir -p logs

# Define the log file path where output will be saved
LOG_FILE="logs/user_info.log"

# Write a header into the log file (overwrite previous content)
echo "==== User Info Script Log ====" > "$LOG_FILE"

# Write the date/time the script was executed into the log file
echo "Run Date: $(date)" >> "$LOG_FILE"

# Add a blank line into the log file for readability
echo "" >> "$LOG_FILE"

# Ask the user to enter their name
# "read" collects user input from the terminal
echo "Enter your name:"
read name

# Check if the name is empty
# -z checks if a variable is empty
if [ -z "$name" ]; then
  echo "Error: Name cannot be empty."
  echo "Error: Name cannot be empty." >> "$LOG_FILE"
  exit 1
fi

# Ask the user to enter their age
echo "Enter your age:"
read age

# Validate that age is numeric
# This checks if age contains ONLY digits (0-9)
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a number."
  echo "Error: Age must be a number." >> "$LOG_FILE"
  exit 1
fi

# Ask the user to enter their country
echo "Enter your country:"
read country

# Check if the country is empty
if [ -z "$country" ]; then
  echo "Error: Country cannot be empty."
  echo "Error: Country cannot be empty." >> "$LOG_FILE"
  exit 1
fi

# Determine age category
# If age is less than 18, user is a minor
if [ "$age" -lt 18 ]; then
  category="Minor"

# If age is between 18 and 65, user is an adult
elif [ "$age" -ge 18 ] && [ "$age" -le 65 ]; then
  category="Adult"

# If age is above 65, user is a senior
else
  category="Senior"
fi

# Display greeting message to the terminal
echo ""
echo "Hello $name from $country!"
echo "You are $age years old, and you are classified as: $category"

# Save the same greeting message into the log file
echo "Name: $name" >> "$LOG_FILE"
echo "Age: $age" >> "$LOG_FILE"
echo "Country: $country" >> "$LOG_FILE"
echo "Category: $category" >> "$LOG_FILE"

# Add a blank line to log file
echo "" >> "$LOG_FILE"

# Write success message to log file
echo "Status: User info saved successfully." >> "$LOG_FILE"

# Inform the user where the log was saved
echo ""
echo "User information has been saved to $LOG_FILE"







