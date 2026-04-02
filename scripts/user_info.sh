#!/bin/bash

LOG_FILE="../logs/user_info.log"

# This checks if the log directory exists and creates if not
mkdir -p "$(dirname "$LOG_FILE")"

echo "==========================================="
echo "     Please answer all the questions below "
echo "==========================================="

# writes the responses to the log file
log_message() {
  echo "$1" | tee -a "$LOG_FILE"
}

# Gets the user name (loop until valid data is entered)
while true; do
  read -p "Tell us your name: " name
  if [[ -n "$name" ]]; then
    break
  else
    echo "Name cannot be empty. Please try again."
  fi
done

# Get age (loop until valid)
while true; do
  read -p "What is your age?: " age
  if [[ "$age" =~ ^[0-9]+$ ]]; then
    break
  else
    echo "Age must be a number. Please try again."
  fi
done

# Get country (loop until valid)
while true; do
  read -p "What country are you from?: " country
  if [[ -n "$country" ]]; then
    break
  else
    echo "Country cannot be empty. Please try again."
  fi
done

# Determine age category
if (( age < 18 )); then
  category="Minor"
elif (( age <= 65 )); then
  category="Adult"
else
  category="Senior"
fi

# Final message
message="Hi $name from $country!
You are a: $category"

echo
log_message "$message"

echo "Your information has been saved!"
