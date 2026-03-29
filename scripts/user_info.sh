#!/bin/bash

mkdir -p logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "All fields are required!" | tee -a logs/user_info.log
    exit 1
fi    

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Age must be a number!" | tee -a logs/user_info.log
    exit 1
fi

if (( age < 18 )); then
     category="Minor"
elif (( age <=65 )); then
      category="Adult"
else 
     category="Senior"
fi

echo "Hello $name from $country. You are an $category." | tee -a logs/user_info.log

