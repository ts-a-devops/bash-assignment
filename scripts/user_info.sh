#!/bin/bash

# 1. Prompt the user for information
read -p "Enter your Name: " NAME
read -p "Enter your Age: " AGE
read -p "Enter your Country: " COUNTRY

# 2. Validate: Age must be numeric
if [[ ! "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
    exit 1
fi

# 3. Categorize by Age
if [ "$AGE" -lt 18 ]; then
    CATEGORY="Minor"
elif [ "$AGE" -ge 18 ] && [ "$AGE" -le 65 ]; then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

# 4. Create the output message
OUTPUT="Hello $NAME from $COUNTRY! You are categorized as: $CATEGORY."

# 5. Display the message and save to the log file
echo "$OUTPUT"
mkdir -p logs
echo "$(date): $OUTPUT" >> logs/user_info.log
