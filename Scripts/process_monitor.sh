Check if the process is running

If NOT running:

Attempt restart (or simulate restart)
Output:

Running systemctl status <nginx>
Stopped systemctl stop <nginx>

Restarted systemctl restart <nginx>

Use an array:

services=("nginx")

Log monitoring results