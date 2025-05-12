#!/bin/bash

# Script to monitor resource usage of Ollama pods
# This will continuously display CPU and memory usage

# Function to print header
print_header() {
  printf "\n%-40s %-10s %-15s\n" "POD" "CPU" "MEMORY"
  printf "%-40s %-10s %-15s\n" "----------------------------------------" "----------" "---------------"
}

# Function to monitor resources
monitor_resources() {
  while true; do
    clear
    echo "Ollama Kubernetes Resource Monitor"
    echo "=================================="
    echo "Press Ctrl+C to exit"
    echo ""
    
    # Get node resources
    echo "Node Resources:"
    /Users/idv/.rd/bin/kubectl top nodes | head -1
    /Users/idv/.rd/bin/kubectl top nodes | grep -v NAME
    
    # Get pod resources
    echo ""
    echo "Ollama Pod Resources:"
    print_header
    
    /Users/idv/.rd/bin/kubectl top pods -n ollama | grep -v NAME | while read line; do
      # Format the output
      pod=$(echo $line | awk '{print $1}')
      cpu=$(echo $line | awk '{print $2}')
      memory=$(echo $line | awk '{print $3}')
      
      printf "%-40s %-10s %-15s\n" "$pod" "$cpu" "$memory"
    done
    
    # Wait before refreshing
    sleep 5
  done
}

# Start monitoring
monitor_resources
