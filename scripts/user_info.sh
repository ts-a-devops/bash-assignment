#!/bin/bash
set -euo pipefail

LOGFILE="logs/user_info.log"

read -p "Enter your name: " NAME
read -p "Enter your age: " AGE
read -p "Enter your country: " COUNTRY

# Validate age is numeric
if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
    echo "$(date) - Invalid age input ($AGE)" >> "$LOGFILE"
    exit 1
fi

# Age category
if (( AGE < 18 )); then
    CATEGORY="Minor"
elif (( AGE <= 65 )); then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

MESSAGE="Hello $NAME from $COUNTRY! You are $AGE years old ($CATEGORY)."
echo "$MESSAGE"

echo "$(date) - $MESSAGE" >> "$LOGFILE"