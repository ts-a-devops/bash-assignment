#!/bin/bash

# Create the logs directory if it doesn't exist
mkdir -p logs

# Prompting the user
echo "Enter your name"
read name

echo "Enter your Age:"
read age

echo "Enter your Country:"
read country


    # Validation: Check if age is a number
if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
    exit 1
fi

# Categorization logic
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adul"
else
    category="Senior"
fi

# Prepare the output message
message="Hello $name from $country! You are $age years old, which makes you a $category."

# Display to user
echo "$message"

# Append to log file with a timestamp
echo "$(date): $message" >> logs/user_info.log:
