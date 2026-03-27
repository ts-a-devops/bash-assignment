set -euo pipefail

LOG_FILE="logs/user_info.log"

read -p "What is your name?: " name
read -p "What is your age?: " age
read -p "Which country are you from?: " country


 if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
     echo "Error: Fill all the fields" | tee -a "$LOG_FILE"
         exit 1
         fi

         if ! [[ "$age" =~ ^[0-9]+$ ]]; then
             echo "Error: Age must be a actual number." | tee -a "$LOG_FILE"
                 exit 1
                 fi


                 if (( age < 18 )); then
                     category="Minor"
                     elif (( age <= 65 )); then
                         category="Adult"
                         else
                             category="Senior"
		 fi

                             message="Hello $name from $country. You are an $category."

                             echo "$message" | tee -a "$LOG_FILE"
