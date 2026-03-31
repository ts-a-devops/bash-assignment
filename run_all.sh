#!/bin/bash

# Strict mode (very important)
set -euo pipefail

# Ensure logs directory exists
mkdir -p logs

LOG_FILE="logs/app.log"

# Logging function
log() {
	    echo "$(date) - $1" | tee -a "$LOG_FILE"
    }

    # Functions
    run_all() {
	        log "Running all scripts..."

		    ./scripts/user_info.sh || log "user_info.sh failed"
		        ./scripts/system_check.sh || log "system_check.sh failed"
			    ./scripts/file_manager.sh list || log "file_manager.sh failed"
			        ./scripts/backup.sh scripts || log "backup.sh failed"

				    log "All scripts executed"
			    }

			    system_check() {
				        log "Running system check..."
					    ./scripts/system_check.sh || log "system_check.sh failed"
				    }

				    backup() {
					        read -p "Enter directory to backup: " dir
						    log "Running backup for $dir..."
						        ./scripts/backup.sh "$dir" || log "backup.sh failed"
						}

						# Menu
						while true; do
							    echo ""
							        echo "===== DevOps Toolkit Menu ====="
								    echo "1. Run All"
								        echo "2. System Check"
									    echo "3. Backup"
									        echo "4. Exit"
										    echo "==============================="

										        read -p "Choose an option [1-4]: " choice

											    case $choice in
												            1)
														                run_all
																            ;;
																	            2)
																			                system_check
																					            ;;
																						            3)
																								                backup
																										            ;;
																											            4)
																													                log "Exiting application..."
																															            exit 0
																																                ;;
																																		        *)
																																				            echo "Invalid option. Please choose between 1-4."
																																					                ;;
																																							    esac
																																						    done
