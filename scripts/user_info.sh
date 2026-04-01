#!/bin/bash

# =========================================================
# USER INFORMATION SCRIPT
# Collects user details, validates input,
# determines age category, and logs the result.
# =========================================================

# ---------------- SETUP LOG DIRECTORY & LOG FILE ----------------

#log_file="logs/user_info.log"

# Ensure logs directory exists
    mkdir -p logs
log_file="logs/user_info.log"


# ---------------- INPUT ----------------

# Collect user details from terminal
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country


# ---------------- VALIDATION ----------------

# Ensure no field is empty
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  echo "Error: All fields (name, age, country) are required."
  exit 1
fi

# Ensure age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a number."
  exit 1
fi


# ---------------- AGE CATEGORY LOGIC ----------------

if (( age < 18 )); then
  category="Minor"
elif (( age <= 65 )); then
  category="Adult"
else
  category="Senior"
fi


# ---------------- OUTPUT MESSAGE ----------------

message="Hello $name from $country! You are $age years old ($category)."

echo "$message"


# ---------------- SAVE TO LOG FILE ----------------

# Append timestamped message to log file
echo "$(date): $message" >> "$log_file"


