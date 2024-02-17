#!/bin/bash

# Extract values from MySQL status output
Threads_created=$(mysql -e "show status like 'Threads_created';" | awk '$1 == "Threads_created" {print $2}')
Connections=$(mysql -e "show status like 'Connections';" | awk '$1 == "Connections" {print $2}')

# Ensure the extracted values are numeric
if [[ "$Threads_created" =~ ^[0-9]+$ && "$Connections" =~ ^[0-9]+$ ]]; then
    # Calculate cache hit rate
    Cache_hit=$((100 - ((Threads_created * 100) / Connections)))

    # Display cache hit rate
    echo "Cache hit rate: $Cache_hit%"
else
    # Display error message if values are not numeric
    echo "Error: Unable to extract numeric values from MySQL status output."
fi
