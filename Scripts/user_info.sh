#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs


# Function to handle invalid input and exit
error_exit() {
    echo "Error: $1"
    exit 1
}

# 1. Prompt for Name
read -p "Enter your Name: " name
if [[ -z "$name" ]]; then
    error_exit "Name cannot be empty."
fi

# 2. Prompt for Age and Validate Numeric Input
read -p "Enter your Age: " age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    error_exit "Age must be a numeric value."
fi

# 3. Prompt for Country
read -p "Enter your Country: " country
if [[ -z "$country" ]]; then
    error_exit "Country cannot be empty."
fi

# 4. Determine Age Category
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

# 5. Format Output
output="Hello $name from $country! You are $age years old, which makes you a $category."

# 6. Display and Log Output
echo "$output"
echo "$(date): $output" >> logs/user_info.log
