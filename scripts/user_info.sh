#!/bin/bash

# ==== Logs file created ====
LOG_FILE="logs/user_info.log"

# ==== Creating logs directory ====
mkdir -p logs

echo "Enter your name:"
read NAME

echo ""

echo "Enter your age:"
read AGE

echo ""

echo "Enter your country:"
read COUNTRY

# ==== Inputes Validation ====
if [[ -z "$NAME" || -z "$AGE" || -z "$COUNTRY" ]]; then
    echo "Error: All fields are required."
    echo "$(date) - ERROR: Missing input" >> $LOG_FILE
    exit 1
fi

# ==== Check if age is numeric ====
if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
    echo "$(date) - ERROR: Invalid age input ($AGE)" >> $LOG_FILE
    exit 1
fi

# ==== Determine age category ====
if (( AGE < 18 )); then
    CATEGORY="Minor"
elif  (( AGE <= 65 )); then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

# ==== Output message ====
MESSAGE="Hello $NAME from $COUNTRY! You are an $CATEGORY."

echo $MESSAGE

# ==== Save to log ====
echo "$(date) - $MESSAGE" >> $LOG_FILE
