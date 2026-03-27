#!/bin/bash
# --------------------------------------------------------------------------
# Script: user_info.sh
# Description: Prompts the user for Name, Age, and Country.
#              Validates numeric age, categorizes the user
#              by age group, and saves the output to a log file.
# --------------------------------------------------------------------------

# Set up the location for our logs. Make sure the directory exists!
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/user_info.log"

echo "=== User Information Script ==="

# 1. Prompt the user for their details using the 'read' command
# The -p flag enables us to show a custom prompt string
read -p "Enter your Name: " user_name
read -p "Enter your Age: " user_age
read -p "Enter your Country: " user_country

# 2. Validate that the input for 'age' is numeric.
# We use a regular expression check (=~ ^[0-9]+$) to ensure it's entirely numbers.
if ! [[ "$user_age" =~ ^[0-9]+$ ]]; then
    # Print error to the user
    echo "Error: Age must be a numeric value."
    # Log the invalid attempt to the log file (graceful error handling)
    # the '>>' appends text without overwriting what is already in the log.
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] Invalid age input ('$user_age') provided by user '$user_name'." >> "$LOG_FILE"
    # Exit the script with an error status (1)
    exit 1
fi

# 3. Age Category Logic
# we utilize normal bash numerical comparisons (-lt for Less Than, -ge for Greater than or Equal to)
if [ "$user_age" -lt 18 ]; then
    category="Minor"
elif [ "$user_age" -ge 18 ] && [ "$user_age" -lt 65 ]; then
    category="Adult"
else
    # Anyone 65 or older falls into this bucket
    category="Senior"
fi

# 4. Generate the personalized output greeting
greeting="Hello $user_name from $user_country. You are $user_age years old, which categorizes you as a(n) $category."

echo "---------------------------------------------------"
echo "$greeting"
echo "---------------------------------------------------"

# 5. Save output to logs/user_info.log
# We use `>>` to append to the log file.
echo "$(date '+%Y-%m-%d %H:%M:%S') [SUCCESS] $greeting" >> "$LOG_FILE"
echo "Output saved to $LOG_FILE"
