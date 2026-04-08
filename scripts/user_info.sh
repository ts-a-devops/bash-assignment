#!/bin/bash

# Save this to log directory

LOG_FILE="logs/user_info.log"

#Now we create that directory if it does not exist

mkdir -p logs

##### Name Section #####
read -p "What is your name? " NAME


#### check if the name contains any value apart from string
while [[ -z "$NAME" || ! "$NAME" =~ ^[a-zA-Z]+$ ]]; do
    read -p "Name must be contain letters " NAME
done


##### Country Section #####

read -p "Hey $NAME what is your country " COUNTRY

#### check if the country contains any value apart from string
while [[ -z "$COUNTRY" || ! "$COUNTRY" =~ ^[a-zA-Z]+$ ]]; do
    read -p "Country must contain letters " COUNTRY
done

##### Age section
read -p "Enter your age? " AGE

#Validation check age mmust contain numbers


while [[ -z "$AGE" || ! $AGE =~ ^[0-9]+$  ]]; do
    read -p " Enter a valid age: " AGE
done


#Age Category####
if [[ $AGE -lt 18 ]]; then
    CATEGORY="Minor"
elif [[ $AGE -le 65 ]]; then
    CATEGORY="Adult"
else 
    CATEGORY="Senior"
fi

### the output message 

MESSAGE="Hello $NAME from $COUNTRY, You are $AGE years old and you are classified as a $CATEGORY"

echo "$MESSAGE" | tee -a  "$LOG_FILE"


