#!/bin/bash

LOGFILE="logs/user_info.log"

echo "What is your name?"
read name

echo "How old are you?"
read age

echo "What country do you resides in?"
read country

if [[ "$age" =~ ^[0-9]+$ ]] && [[ "$age" -le 17 ]]; then
    echo "Welcome to TS Academy $name from $country, unfortunatly you are a minor and can't register for this course" >> "$LOGFILE"
elif [[ "$age" =~ ^[0-9]+$ ]] && [[ "$age" -ge 18 && "$age" -le 65 ]]; then
    echo "Welcome to TS Academy $name from $country, fortunately you are an adult and can register for this course" >> "$LOGFILE"
elif [[ "$age" =~ ^[0-9]+$ ]] && [[ "$age" -gt 65 ]]; then
    echo "Welcome to TS Academy $name from country, you are in the senior category and eligible for certification" >> "$LOGFILE"
else
    echo "You are not getting any response because you entered a wrong detail" >> "$LOGFILE"
fi
