#!/bin/bash

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

#Check if age is a numeric value

if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Invalid age. Must be a number"
    exit 1
fi

if [[ "$age" -lt 18 ]]; then
    category="a minor"
elif [[ "$age" -eq 18 && "$age" -lt 65 ]]; then
    category="an adult"
else 
    category="a senior"
fi

msg="Hello $name from $country. You are $category"

echo "$msg"

echo "$msg" > ../logs/user_info.log
