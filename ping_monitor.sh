#!/bin/bash

#!/bin/sh
echo "+----------------------------------------------------------------------+"
echo "| Upinel/Ping-Monitor                                                  |"
echo "| https://github.com/Upinel/Ping-Monitor                               |"
echo "+----------------------------------------------------------------------+"
echo "| This source file is subject to version 2.0 of the Apache license,    |"
echo "| that is bundled with this package in the file LICENSE, and is        |"
echo "| available through the world-wide-web at the following url:           |"
echo "| http://www.apache.org/licenses/LICENSE-2.0.html                      |"
echo "| If you did not receive a copy of the Apache2.0 license and are unable|"
echo "| to obtain it through the world-wide-web, please send a note to       |"
echo "| license@swoole.com so we can mail you a copy immediately.            |"
echo "+----------------------------------------------------------------------+"
echo "| Author: Nova Upinel Chow  <dev@upinel.com>                           |"
echo "| Date:   03/Mar/2024                                                  |"
echo "+----------------------------------------------------------------------+"
echo "The Ping-Monitor is now running..."

# Initialize variables
success_count=0
error_message=""
last_three_success=()
LOG_FILE="ping_event.log"
normal_log_interval=600 # Log normal operation every 600 seconds (10 minutes)
last_log_time=$(date +%s)

# Function to write to the log file with a timestamp
write_log() {
  local message="$1"
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "$timestamp - $message" >> $LOG_FILE
}

# Function to log successful pings
log_success() {
  local icmp_seq="$1"
  local timestamp="$2"
  # Prepend to the success ping array and keep only the last 3 elements
  last_three_success=("$timestamp icmp_seq=$icmp_seq" "${last_three_success[@]:0:2}")
}

# Function to log normal operation
log_normal_operation() {
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  write_log "Normal operation"
  for i in "${last_three_success[@]}"; do
    echo "   Last successful ping: $i" >> $LOG_FILE
  done
}

# Function to log errors and the last three successful pings
log_error() {
  local timestamp="$1"
  write_log "Connection lost"
  for i in "${last_three_success[@]}"; do
    echo "   Success before error: $i" >> $LOG_FILE
  done
}

# Function to log connection resumes
log_resume() {
  local timestamp="$1"
  write_log "Connection resumed"
}

# Function to log script start
log_start() {
  write_log "Ping monitor script started"
}

# Function to log script end
log_end() {
  write_log "Ping monitor script ended"
}

# Trap CTRL+C to execute the log_end function
trap log_end SIGINT

# Log script start event
log_start

# Infinite loop to keep pinging
while true; do
  # Ping google dns with a timeout of 1 second
  if ping -c 1 -W 1 8.8.8.8 | grep --line-buffered 'icmp_seq=' > /dev/null 2>&1; then
    # Extract icmp_seq from ping output
    icmp_seq=$(ping -c 1 -W 1 8.8.8.8 | grep --line-buffered 'icmp_seq=' | sed -nE 's/.*icmp_seq=([0-9]+).*/\1/p')
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    # Log success if error previously occurred
    if [[ $success_count -eq 0 && $error_message != "" ]]; then
      log_resume "$timestamp"
      error_message=""
    fi
    # Reset success count
    success_count=3
    # Log successful ping
    log_success "$icmp_seq" "$timestamp"
  else
    if [[ $success_count -gt 0 ]]; then
      error_message="Connection error"
      timestamp=$(date "+%Y-%m-%d %H:%M:%S")
      log_error "$timestamp"
    fi
    ((success_count--))
  fi

  # Check if 10 minutes have passed to log normal operation
  current_time=$(date +%s)
  if (( current_time - last_log_time >= normal_log_interval )); then
    log_normal_operation
    last_log_time=$current_time
  fi
  
  sleep 1
done

# Log script end event
log_end