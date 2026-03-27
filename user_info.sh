 #!/bin/bash
   
 mkdir -p logs
 LOG_FILE="logs/user_info.log"



 read -p "Enter your name:" name
 read -p "Enter your age:" age
 read -p "Enter your country:" country

 timestamp=$(date +"%Y-%m-5d %H:%M:%S")


 # Validate missing input
 if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
     message="[$timestamp] Erorr: All fields (name, age, country) are required."
     echo "message"
     echo "message" >> "$LOG_FILE"
     exit 1
 fi


 # Validate numeric age
 if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    message="[$timestamp] Error: Age must be a numeric value."
    echo "$message"
    echo "$message" >> "$LOG_FILE"
    exit 1
 fi

 # Determine age category
 if (( age < 18 )); then
    category="Minor"
 elif (( age <= 65 )); then
     category="Adult"
 else
     category="Senior"
 fi

 message="[$timestamp] Hello, $name from $country. You are $age years old and belong to the '$category' category."

 echo "$message"
 echo "$message" >> "$LOG_FILE"
