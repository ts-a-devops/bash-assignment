#!/bin/bash

read -p "Enter name: " name
read -p "Enter age: " age
read -p "Enter country: " country

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Invalid age" | tee -a logs/user_info.log
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