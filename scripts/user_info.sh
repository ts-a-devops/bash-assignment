#!/bin/bash

mkdir -p logs

read -p "What is your name? " name

if [ -z  "$name" ]; then
    echo "Name cannot be empty."
    exit 1
fi

read -p "What is your age? " age

if ! echo "$age" | grep -q '^[0-9]\+$'
then
    echo "Age must be a number."
    exit 1
fi

read -p "What country are you from? " country

if [ -z "$country" ]; then
    echo "Country cannot be empty."
exit 1
fi

if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

echo "Hello $name from $country!"
echo "You are an $category."

echo "Name: $name | Age: $age | Country:
$country | Category: $category" >> ../logs/user_info.log
