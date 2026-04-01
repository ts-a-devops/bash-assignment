#!/bin/bash

mkdir -p logs

name="Florence"
age=32
country="Nigeria"

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a number!"
  exit 1
fi

if [ "$age" -lt 18 ]; then
  category="Minor"
elif [ "$age" -le 65 ]; then
  category="Adult"
else
  category="Senior"
fi

echo "Hello $name! You are $age years old from $country. Category: $category"
echo "Name: $name, Age: $age, Country: $country, Category: $category" >> logs/user_info.log
echo "Output saved to logs/user_info.log"
