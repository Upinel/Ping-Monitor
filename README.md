# Ping Monitor

A simple Bash script for Linux / Mac / WSL to monitor the connectivity to a specified IP address (Google DNS 8.8.8.8 by default) by sending ping requests and logging the results. The script logs connectivity issues, successful pings, and every 10 minutes logs a status update showing that everything is running normally, along with the last three successful pings.

# Prerequisites

• Linux / Mac / WSL operating system with Bash
• Ping utility installed (usually pre-installed on most Linux distributions)

Installation

1. Clone the repository:
```bash
git clone https://github.com/upinel/ping-monitor.git
```

2. Change into the directory:
```bash
cd ping-monitor
```

3. Make the script executable:
```bash
chmod +x ping_monitor.sh
```

# Usage

To start the monitoring, run the script from the terminal:
```bash
./ping_monitor.sh
```

The script will continue to run until it is stopped with CTRL+C or the terminal is closed.

# Log file

The script will create a log file named ping_event.log in the same directory where the script is running. This log file will contain all the events and messages related to the ping operations.

The log entries include:

• Timestamp and message when the script starts
• Timestamp for each successful ping (logged every second)
• Timestamp for a connection loss, and the last three successful pings before the loss
• Timestamp when the connection is re-established after a loss
• A timestamped “Normal operation” message, and the last three successful pings every 10 minutes
• Timestamp and message when the script is manually ended

# Configurations

You can edit ping_monitor.sh to change the IP address that is being pinged, or to modify the log file path and name. The normal_log_interval can also be changed to customize how often the regular status update is logged.

# Contributing

Contributions are welcome! Feel free to submit a pull request or create an issue if you have an idea for an improvement or find an issue.

# License
This project is licensed under Apache License, Version 2.0.

# Author
Nova Upinel Chow  
Email: dev@upinel.com

# Buy me a coffee
If you wish to donate us, please donate to [https://paypal.me/Upinel](https://paypal.me/Upinel), it will be really lovely.