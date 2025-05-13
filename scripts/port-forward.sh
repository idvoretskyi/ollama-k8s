#!/bin/bash

# Script to set up port forwarding for Ollama and Web UI
# This will allow access to Ollama API at localhost:11434
# and the Web UI at localhost:8080

# Define paths
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Set color variables
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
  if command -v minikube &> /dev/null; then
    # If using minikube, set the kubectl alias
    echo -e "${YELLOW}Using minikube kubectl...${NC}"
    KUBECTL="minikube kubectl --"
  else
    echo -e "${RED}kubectl not found. Please install kubectl or minikube and try again.${NC}"
    exit 1
  fi
else
  # Set kubectl path dynamically
  KUBECTL=$(which kubectl)
fi

echo -e "${GREEN}Setting up port forwarding...${NC}"

# Check if namespace exists
if ! $KUBECTL get namespace ollama &> /dev/null; then
  echo -e "${RED}Namespace 'ollama' not found. Please deploy Ollama first.${NC}"
  exit 1
fi

# Wait for pods to be ready
echo -e "${YELLOW}Waiting for Ollama pods to be ready...${NC}"
$KUBECTL wait --for=condition=ready pod -l app=ollama -n ollama --timeout=120s || {
  echo -e "${RED}Timed out waiting for Ollama pods to be ready.${NC}"
  echo -e "${YELLOW}Attempting to port-forward anyway...${NC}"
}

echo -e "${YELLOW}Waiting for WebUI pods to be ready...${NC}"
$KUBECTL wait --for=condition=ready pod -l app=ollama-webui -n ollama --timeout=60s || {
  echo -e "${RED}Timed out waiting for WebUI pods to be ready.${NC}"
  echo -e "${YELLOW}Attempting to port-forward anyway...${NC}"
}

# Debug information
echo -e "\n${GREEN}Pod status:${NC}"
$KUBECTL get pods -n ollama
echo -e "\n${GREEN}Service status:${NC}"
$KUBECTL get svc -n ollama
echo -e ""

# Function to start port forwarding with retry
start_port_forwarding() {
  local service=$1
  local local_port=$2
  local target_port=$3
  local max_attempts=3
  local attempt=1
  local pid=0
  
  # Check for existing connections on the port
  check_port_in_use $local_port
  
  while [ $attempt -le $max_attempts ]; do
    echo -e "${YELLOW}Starting port forwarding for $service on localhost:$local_port (Attempt $attempt/$max_attempts)...${NC}"
    $KUBECTL port-forward -n ollama svc/$service $local_port:$target_port &
    pid=$!
    
    # Wait a moment to see if port forwarding establishes
    sleep 3
    
    # Test if the connection works - use different checks for Ollama API vs WebUI
    if kill -0 $pid 2>/dev/null; then
      # Different check methods for different services
      if [ "$service" = "ollama" ]; then
        if curl -s --connect-timeout 2 http://localhost:$local_port/api/version >/dev/null 2>&1; then
          echo -e "${GREEN}Port forwarding for $service started successfully (PID: $pid).${NC}"
          echo $pid
          return 0
        fi
      elif [ "$service" = "ollama-webui" ]; then
        # For WebUI, check if the port is listening
        local port_check=false
        
        # Try different methods to check if port is up
        if command -v nc &> /dev/null; then
          if nc -z localhost $local_port >/dev/null 2>&1; then
            port_check=true
          fi
        elif command -v lsof &> /dev/null; then
          if lsof -i:$local_port &>/dev/null; then
            port_check=true
          fi
        elif command -v curl &> /dev/null; then
          if curl -s --head --fail --connect-timeout 2 http://localhost:$local_port >/dev/null 2>&1; then
            port_check=true
          fi
        else
          # Fallback: Assume the port is accessible if the port-forwarding process is running.
          # This is to prevent the script from failing in environments where no port-checking tools are available.
          port_check=true
        fi
        
        if $port_check; then
          echo -e "${GREEN}Port forwarding for $service started successfully (PID: $pid).${NC}"
          echo $pid
          return 0
        fi
      fi
    fi
    
    echo -e "${RED}Failed to establish port forwarding for $service (Attempt $attempt/$max_attempts).${NC}"
    kill $pid 2>/dev/null
    attempt=$((attempt+1))
    sleep 2
  done
  
  echo -e "${RED}All attempts to establish port forwarding for $service failed.${NC}"
  return 1
}

# Start port forwarding for Ollama API with retry
OLLAMA_PID=$(start_port_forwarding "ollama" 11434 11434)
OLLAMA_STATUS=$?

# Start port forwarding for Web UI with retry
WEBUI_PID=$(start_port_forwarding "ollama-webui" 8080 8080)
WEBUI_STATUS=$?

# Check if port forwarding was successful
if [ $OLLAMA_STATUS -ne 0 ] || [ $WEBUI_STATUS -ne 0 ]; then
  echo -e "${RED}Failed to establish port forwarding for at least one service.${NC}"
  echo -e "${YELLOW}Here's some troubleshooting information:${NC}"
  echo -e "1. Check if services exist and are running:"
  $KUBECTL get svc -n ollama
  $KUBECTL get pods -n ollama
  echo -e "2. Try manually with: kubectl port-forward -n ollama svc/ollama 11434:11434"
  echo -e "3. If using Codespaces, ensure you're using port forwarding through ports tab"
else
  echo -e "${GREEN}Port forwarding active. Press Ctrl+C to stop.${NC}"
fi

# Function to cleanup port forwarding on exit
cleanup() {
  echo -e "\n${YELLOW}Stopping port forwarding...${NC}"
  kill $OLLAMA_PID 2>/dev/null
  kill $WEBUI_PID 2>/dev/null
  exit 0
}

# Set up trap to catch Ctrl+C and other termination signals
trap cleanup SIGINT SIGTERM EXIT

# Keep the script running and provide usage instructions
echo -e "${GREEN}Access WebUI at: ${NC}http://localhost:8080"
echo -e "${GREEN}Access Ollama API at: ${NC}http://localhost:11434"
while true; do
  sleep 1
done
