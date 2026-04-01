#!/bin/bash

LOG_FILES="..logs/user_info.log"
mkdir -p logs

read -p="Enter your name" name
read -p="Enter your age" age 
read -p="Enter your country" country

# validate input 
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
	echo "Error: all value are required"
	exit 1
fi

# validate numeric input
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
	echo "Error: age must be numerical"
	exit 1
fi

# age category 
if (( age < 18 )); then
       category="minor"
elif (( age <= 65 )); then
       category="adult"
else 
      category="senior"
fi

message="Hello $name, you are $age from $country and your category is $category"
echo "$message"

# save file to logs

echo "$message" >> logs/user_info.log

