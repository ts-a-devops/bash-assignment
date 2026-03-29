#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"

mkdir -p "$LOG_DIR"

read -p "Enter your name: " NAME
read -p "Enter your age: " AGE
read -p "Enter your country: " COUNTRY

# Validate inputs
if [[ -z "$NAME" || -z "$AGE" || -z "$COUNTRY" ]]; then
    echo "Error: All fields are required."
    echo "$(date) - Missing input" >> "$LOG_FILE"
    exit 1
fi

if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be numeric."
    echo "$(date) - Invalid age input: $AGE" >> "$LOG_FILE"
    exit 1
fi

# Determine age category
if (( AGE < 18 )); then
    CATEGORY="Minor"
elif (( AGE <= 65 )); then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

MESSAGE="Hello $NAME from $COUNTRY! You are an $CATEGORY."

echo "$MESSAGE"
echo "$(date) - $MESSAGE" >> "$LOG_FILE"

