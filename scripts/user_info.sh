#!/bin/bash
mkdir -p ./logs

read -p "Enter your name: " name

while [[ -z "$name" ]]
do
    echo "Name cannot be blank."
    read -p "Enter your name: " name
done
read -p "Enter your age: " age

while [[ ! "$age" =~ ^[0-9]+$ ]]
do
    echo "Age must be numeric."
    read -p "Enter your age: " age
done

read -p "Enter your country of origin: " country

while [[ -z "$country" ]]
do
    echo "Country cannot be blank."
    read -p "Enter your country of origin: " country
done
if [[ "$age" -lt 18 ]]
then
    echo "Hello $name. You are a minor." | tee -a ./logs/user_info.log

elif [[ "$age" -gt 17 ]] && [[ "$age" -lt 66 ]]
then
    echo "Hello $name. You are an adult." | tee -a ./logs/user_info.log
 

elif [[ "$age" -gt 65 ]]
then
    echo "Hello $name. You are a senior." | tee -a ./logs/user_info.log


fi
        
