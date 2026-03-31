#!/bin/bash

# Ensure logs directory exists
mkdir -p ../logs

LOG_FILE="../logs/process_monitor.log"

# Predefined services
services=("nginx" "ssh" "docker")

echo "===== Process Monitor ====="

# If user provides a process name, use it
if [ $# -ge 1 ]; then
	    services=("$1")
fi

# Loop through services
for service in "${services[@]}"; do

	    if pgrep -x "$service" > /dev/null; then
		            echo "$service is RUNNING"
			            echo "$(date) - $service: RUNNING" >> "$LOG_FILE"
				        else
						        echo "$service is STOPPED"
							        echo "$(date) - $service: STOPPED" >> "$LOG_FILE"

								        echo "Attempting to restart $service..."

									        # Try restarting (may require sudo)
										        if command -v systemctl > /dev/null; then
												            sudo systemctl restart "$service" 2>/dev/null || true
													            else
															                # Fallback simulation if systemctl not available
																	            echo "Simulating restart of $service..."
																		            fi

																			            # Check again after restart attempt
																				            if pgrep -x "$service" > /dev/null; then
																						                echo "$service successfully RESTARTED"
																								            echo "$(date) - $service: RESTARTED" >> "$LOG_FILE"
																									            else
																											                echo "Failed to restart $service (or simulated)"
																													            echo "$(date) - $service: RESTART FAILED" >> "$LOG_FILE"
																														            fi
																															        fi

																															done

																															echo "Monitoring complete. Logs saved to $LOG_FILE"
