#!/bin/bash

LOG_FILE="logs/user_info.log"

read -p "Enter your name: " NAME
read -p "Enter your age: " AGE
read -p "Enter your country: " COUNTRY

# Validate input
if [[ -z "$NAME" || -z "$AGE" || -z "$COUNTRY" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be numeric."
    exit 1
fi

# Age category
if [ "$AGE" -lt 18 ]; then
    CATEGORY="Minor"
elif [ "$AGE" -le 65 ]; then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

echo "Hello $NAME from $COUNTRY"
echo "Category: $CATEGORY"

# Log output
{
    echo "Date: $(date)"
    echo "Name: $NAME"
    echo "Age: $AGE"
    echo "Country: $COUNTRY"
    echo "Category: $CATEGORY"
    echo "----------------------"
} >> "$LOG_FILE"
