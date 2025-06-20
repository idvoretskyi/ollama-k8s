#!/bin/bash

# Ollama API Test Script
# This script tests the Ollama API connection and shows available models

# Define paths
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║               Ollama API Test Utility                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
  if command -v minikube &> /dev/null; then
    # If using minikube, set the kubectl alias
    KUBECTL="minikube kubectl --"
  else
    echo -e "${RED}kubectl not found. Please install kubectl or minikube and try again.${NC}"
    exit 1
  fi
else
  # Set kubectl path dynamically
  KUBECTL=$(which kubectl)
fi

# Function to get service IP
get_service_ip() {
  $KUBECTL get svc -n ollama ollama -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null
}

# Function to check if the API is accessible
test_api() {
  local ip=$1
  echo -e "${YELLOW}Testing Ollama API connection to ${ip}:11434...${NC}"
  
  # Try to get the version
  version=$(curl -s --connect-timeout 5 http://${ip}:11434/api/version)
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to connect to Ollama API.${NC}"
    return 1
  fi
  
  echo -e "${GREEN}Successfully connected to Ollama API!${NC}"
  echo "API Version: ${version}"
  echo ""
  return 0
}

# Function to list models
list_models() {
  local ip=$1
  echo -e "${YELLOW}Fetching available models...${NC}"
  
  # Try to get the models
  models=$(curl -s --connect-timeout 5 http://${ip}:11434/api/tags)
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to get models.${NC}"
    return 1
  fi
  
  if [[ $models == *"models"* || $models == *"object"* ]]; then
    echo -e "${GREEN}Available models:${NC}"
    echo "$models" | grep -o '"name":"[^"]*' | cut -d'"' -f4
  else
    echo -e "${YELLOW}No models found. Try pulling a model first:${NC}"
    echo "$BASE_DIR/scripts/pull-model.sh phi3-mini"
  fi
  
  return 0
}

# Try connecting via service IP
echo "Checking for Ollama service..."
SERVICE_IP=$(get_service_ip)

if [ -n "$SERVICE_IP" ]; then
  echo -e "${GREEN}Found Ollama service at ${SERVICE_IP}${NC}"
  
  if test_api $SERVICE_IP; then
    list_models $SERVICE_IP
  else
    echo -e "${YELLOW}API not available yet. The pod might still be starting.${NC}"
    echo -e "Run ${GREEN}kubectl get pods -n ollama${NC} to check status."
  fi
else
  echo -e "${YELLOW}Ollama service not found or doesn't have an external IP yet.${NC}"
  echo -e "Make sure you've run ${GREEN}$BASE_DIR/scripts/start.sh${NC} or ${GREEN}$BASE_DIR/scripts/codespaces-start.sh${NC}"
  echo -e "Then check deployment status with: ${GREEN}kubectl get pods -n ollama${NC}"
fi

# Try localhost (for port forwarding)
echo ""
echo -e "${YELLOW}Testing localhost connection (if port-forwarding is active)...${NC}"

if test_api "localhost"; then
  list_models "localhost"
else
  echo -e "${YELLOW}Localhost connection not available.${NC}"
  echo -e "You can enable port forwarding with: ${GREEN}$BASE_DIR/scripts/port-forward.sh${NC}"
fi

echo ""
echo -e "${BLUE}For more information, see $BASE_DIR/README.md${NC}"
