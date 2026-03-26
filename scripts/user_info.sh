#!/bin/bash

# 1. Ask the user for their information
read -p "Enter your Name: " name
read -p "Enter your Age: " age
read -p "Enter your Country: " country

# 2. Logic: Decide if they are a Minor, Adult, or Senior
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

# 3. Create the message
result="Hello $name from $country! You are a(n) $category."

# 4. Show the message and save it to the log file
echo "$result" | tee -a logs/user_info.log