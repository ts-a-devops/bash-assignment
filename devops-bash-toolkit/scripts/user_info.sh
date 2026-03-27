#!/bin/bash

read -p "Enter your name: " NAME

while true; do
    read -p "Enter your age: " AGE
    
    # Check if it's a positive integer
    if [[ "$AGE" =~ ^[0-9]+$ ]]; then
        break  # Exit the loop if valid
    else
        echo "Error: Please enter a valid numeric age! "
    fi
done

read -p "What country are you from: " COUNTRY

if [[ "$AGE" -lt 18 ]]; then
    echo "Hello $NAME, your age is $AGE, which means you're a minor and you're from $COUNTRY" >> ../logs/user_info.log
elif [[ "$AGE" -le 65 ]]; then
    echo "Hello $NAME, your age is $AGE, which means you're an adult and you're from $COUNTRY" >> ../logs/user_info.log
else
    echo "Hello $NAME, your age is $AGE, which means you're a senior and you're from $COUNTRY" >> ../logs/user_info.log
fi


