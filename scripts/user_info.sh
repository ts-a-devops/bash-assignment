
#!/bin/bash

# Create logs folder if it doesn't exist
mkdir -p logs

# Ask user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate inputs
if [ -z "$name" ] || [ -z "$age" ] || [ -z "$country" ]; then
  echo "Error: All fields are required"
  exit 1
fi

# Check if age is a number
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a number"
  exit 1
fi

# Determine age category
if [ "$age" -lt 18 ]; then
  category="Minor"
elif [ "$age" -le 65 ]; then
  category="Adult"
else
  category="Senior"
fi

# Output message
message="Hello $name from $country! You are an $category."

echo "$message"

# Save to log
echo "$(date): $message" >> logs/user_info.log


