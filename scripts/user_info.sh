#!/usr/bin/env bash

mkdir -p logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
echo "Invalid age input"
exit 1
fi

if [ "$age" -lt 18 ]; then
category="Minor"
elif [ "$age" -le 65 ]; then
category="Adult"
else
category="Senior"
fi

echo "Hello $name from $country. You are an $category." | tee -a logs/user_info.log