
#!/bin/bash
# This tells Linux to run this script using the bash shell

# Create logs directory if it doesn't exist
# This prevents errors when saving log files
mkdir -p logs

# Store the current date and time in a variable
# This will help us create unique log file names
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Define the log file name using the current date
LOG_FILE="logs/system_report_${DATE}.log"

# Write a header into the log file
echo "==============================" > "$LOG_FILE"
echo "     SYSTEM CHECK REPORT      " >> "$LOG_FILE"
echo "==============================" >> "$LOG_FILE"

# Add the date/time the report was generated
echo "Generated on: $(date)" >> "$LOG_FILE"

# Add an empty line for readability
echo "" >> "$LOG_FILE"


# -------------------------------
# DISK USAGE SECTION
# -------------------------------

# Print disk usage header to terminal
echo "Checking Disk Usage..."

# Save disk usage header to log file
echo "----- DISK USAGE (df -h) -----" >> "$LOG_FILE"

# Run df -h to show disk usage in human readable format
# Save output into log file
df -h >> "$LOG_FILE"

# Add empty line in log file
echo "" >> "$LOG_FILE"


# -------------------------------
# DISK USAGE WARNING SECTION
# -------------------------------

# Check if any disk usage is above 80%
# We use df -h and extract the percentage column (5th column)
# Then we remove the "%" sign and compare the numbers

# Save warning header to log file
echo "----- DISK WARNING CHECK -----" >> "$LOG_FILE"

# Extract disk usage percentages and check if any is above 80
# awk reads each line and checks the 5th column (Use%)
# NR>1 skips the first header row
DISK_WARNING=$(df -h | awk 'NR>1 {gsub("%","",$5); if($5 > 80) print $0}')

# If DISK_WARNING is not empty, then a disk is above 80%
if [ -n "$DISK_WARNING" ]; then
  echo "WARNING: Disk usage above 80% detected!"
  echo "WARNING: Disk usage above 80% detected!" >> "$LOG_FILE"
  echo "$DISK_WARNING" >> "$LOG_FILE"
else
  echo "Disk usage is okay (below 80%)."
  echo "Disk usage is okay (below 80%)." >> "$LOG_FILE"
fi

# Add empty line in log file
echo "" >> "$LOG_FILE"


# -------------------------------
# MEMORY USAGE SECTION
# -------------------------------

# Print memory check message to terminal
echo "Checking Memory Usage..."

# Save memory usage header to log file
echo "----- MEMORY USAGE (free -m) -----" >> "$LOG_FILE"

# Run free -m to show memory usage in MB
# Save output into log file
free -m >> "$LOG_FILE"

# Add empty line
echo "" >> "$LOG_FILE"


# -------------------------------
# CPU LOAD SECTION
# -------------------------------

# Print CPU load message to terminal
echo "Checking CPU Load..."

# Save CPU load header to log file
echo "----- CPU LOAD (uptime) -----" >> "$LOG_FILE"

# Run uptime command and save output into log file
uptime >> "$LOG_FILE"

# Add empty line
echo "" >> "$LOG_FILE"


# -------------------------------
# TOTAL RUNNING PROCESSES
# -------------------------------

# Print process count message to terminal
echo "Counting Running Processes..."

# Save header into log file
echo "----- TOTAL RUNNING PROCESSES -----" >> "$LOG_FILE"

# ps -e shows all processes
# wc -l counts how many lines (processes)
TOTAL_PROCESSES=$(ps -e | wc -l)

# Save total processes into log file
echo "Total Running Processes: $TOTAL_PROCESSES" >> "$LOG_FILE"

# Add empty line
echo "" >> "$LOG_FILE"


# -------------------------------
# TOP 5 MEMORY CONSUMING PROCESSES
# -------------------------------

# Print top processes message to terminal
echo "Checking Top 5 Memory Consuming Processes..."

# Save header into log file
echo "----- TOP 5 MEMORY CONSUMING PROCESSES -----" >> "$LOG_FILE"

# ps aux shows detailed process list
# --sort=-%mem sorts processes by memory usage (descending order)
# head -n 6 gives 6 lines (1 header + top 5 processes)
ps aux --sort=-%mem | head -n 6 >> "$LOG_FILE"

# Add empty line
echo "" >> "$LOG_FILE"


# -------------------------------
# FINAL MESSAGE
# -------------------------------

# Print final message to terminal
echo "System check completed."

# Print log file location to terminal
echo "Report saved to: $LOG_FILE"

# Save completion status into log file
echo "System check completed successfully." >> "$LOG_FILE"
