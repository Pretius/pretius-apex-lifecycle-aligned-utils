#!/bin/bash

url="$1"
timeout=300 # 5 minutes in seconds
retry_interval=10 # retry every 10 seconds 
echo $url
# Start timer
start_time=$(date +%s)

# Loop until timeout
while (( $(date +%s) - $start_time < $timeout )); do
  # Try to reach the URL
  if curl --output /dev/null --silent --head --fail "$url"; then
    echo "APEX URL has been contacted"
    exit 0
  else
    echo "APEX URL is not reachable, retrying in $retry_interval seconds..."
    sleep $retry_interval
  fi
done

# Report Jenkins error
echo "APEX URL could not be reached within $timeout seconds"
echo "Reporting Jenkins error..." 
exit 1

