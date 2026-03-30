#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"

mkdir -p "$LOG_DIR"

echo -n "Enter your name: "
read NAME

echo -n "Enter your age: "
read AGE

echo -n "Enter your country: "
read COUNTRY

# Validate age
if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be numeric." | tee -a "$LOG_FILE"
    exit 1
fi

# Determine age category
if [ "$AGE" -lt 18 ]; then
    CATEGORY="Minor"
elif [ "$AGE" -le 65 ]; then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

MESSAGE="Hello $NAME from $COUNTRY! You are $AGE years old and categorized as: $CATEGORY."

echo "$MESSAGE"
echo "$(date): $MESSAGE" >> "$LOG_FILE"
