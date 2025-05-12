#!/bin/bash

# Script to set up port forwarding for Ollama and Web UI
# This will allow access to Ollama API at localhost:11434
# and the Web UI at localhost:8080

# Start port forwarding for Ollama API
echo "Starting port forwarding for Ollama API on localhost:11434..."
/Users/idv/.rd/bin/kubectl port-forward -n ollama svc/ollama 11434:11434 &
OLLAMA_PID=$!

# Start port forwarding for Web UI
echo "Starting port forwarding for Web UI on localhost:8080..."
/Users/idv/.rd/bin/kubectl port-forward -n ollama svc/ollama-webui 8080:8080 &
WEBUI_PID=$!

echo "Port forwarding active. Press Ctrl+C to stop."

# Function to cleanup port forwarding on exit
cleanup() {
  echo "Stopping port forwarding..."
  kill $OLLAMA_PID 2>/dev/null
  kill $WEBUI_PID 2>/dev/null
  exit 0
}

# Set up trap to catch Ctrl+C and other termination signals
trap cleanup SIGINT SIGTERM EXIT

# Keep the script running
echo "Access WebUI at: http://localhost:8080"
echo "Access Ollama API at: http://localhost:11434"
while true; do
  sleep 1
done
