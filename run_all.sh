

      #!/bin/bash
           set -euo pipefail

           log="logs/app.log"

           run_all() {
           bash scripts/system_check.sh
           bash scripts/backup.sh .
            }

           echo "1. Run all"
           echo "2. System check"
           echo "3. Backup"
           echo "4. Exit"

           read choice

           case $choice in
                1) run_all ;;
                2) bash scripts/system_check.sh ;;
                3) bash scripts/backup.sh . ;
		4) exit ;;
                *) echo "Invalid option" ;;
           esac


           echo "$(date): Action executed" >> $log
